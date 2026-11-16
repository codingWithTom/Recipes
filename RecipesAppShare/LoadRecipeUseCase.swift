//
//  LoadRecipeUseCase.swift
//  RecipesAppShare
//
//  Created by Tomas Trujillo on 2026-05-11.
//

import Foundation

struct LoadRecipeUseCase {
  enum LoadingError: Error {
    case badData
    case invalidFormat
  }

  func execute(url: URL) async throws -> ImportedRecipe {
    var request = URLRequest(url: url)
    request.setValue("Mozilla/5.0 (compatibel; RecipesApp/1.0)", forHTTPHeaderField: "User-Agent")
    let (data, _) = try await URLSession.shared.data(for: request)
    guard let html = String(data: data, encoding: .utf8) else {
      throw LoadingError.badData
    }
    let blocks = extractLDJsonBlocks(from: html)
    for block in blocks {
      if let recipeNode = findRecipeNode(in: block) {
        return await RecipeBlockMapper().map(from: recipeNode)
      }
    }
    
    throw LoadingError.invalidFormat
  }
  
  private func extractLDJsonBlocks(from html: String) -> [Any] {
    let pattern = #"<script[^>]*type=["']application/ld\+json["'][^>]*>([\s\S]*?)</script>"#
    guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else { return [] }
    let nsHTML = html as NSString
    let matches = regex.matches(in: html, range: NSRange(location: 0, length: nsHTML.length))
    return matches.compactMap { match -> Any? in
      guard match.numberOfRanges >= 2 else { return nil }
      let raw = nsHTML.substring(with: match.range(at: 1))
      return try? JSONSerialization.jsonObject(with: Data(raw.utf8))
    }
  }
  
  private func findRecipeNode(in node: Any) -> [String: Any]? {
    if let dict = node as? [String: Any] {
      
      if isTypeRecipe(dict) {
        return dict
      }
      
      if let graph = dict["@graph"] as? [Any] {
        for child in graph {
          guard let recipe = findRecipeNode(in: child) else { continue }
          return recipe
        }
      }
    }
    
    if let array = node as? [Any] {
      for child in array {
        guard let recipe = findRecipeNode(in: child) else { continue }
        return recipe
      }
    }
    return nil
  }
  
  private func isTypeRecipe(_ dict: [String: Any]) -> Bool {
    let type = dict["@type"]
    if let string = type as? String {
      return string == "Recipe"
    } else if let array = type as? [String] {
      return array.contains("Recipe")
    }
    return false
  }
}

private struct RecipeBlockMapper {
  func map(from json: [String: Any]) async -> ImportedRecipe {
    let title = string(json["title"])
    let subtitle = String(string(json["description"]).prefix(200))
    let imageData = await image(from: json["image"])
    let cookTime = minutes(from: json["cookTime"]) ?? minutes(from: json["totalTime"])
    let servings = servingsCount(from: json["recipeYield"])
    let ingredients = json["recipeIngredient"] as? [String] ?? []
    let steps = flattenInstructions(from: json["recipeInstructions"])
    return ImportedRecipe(
      title: title,
      subtitle: subtitle,
      imageData: imageData,
      cookTime: cookTime ?? 0,
      servings: servings ?? 0,
      components: [
        .init(
          title: "",
          ingredients: ingredients.map { ImportedIngredient(name: $0, icon: "", unit: "", quantity: "")}
        )
      ],
      steps: steps.map { ImportedStep(text: $0) }
    )
  }
  
  private func string(_ any: Any?, key: String = "value") -> String {
    if let string = any as? String {
      return string
    } else if let array = any as? [String] {
      return array.first ?? ""
    } else if let dict = any as? [String: Any], let string = dict[key] as? String {
      return string
    }
    return ""
  }
  
  private func image(from any: Any?) async -> Data? {
    let imageURL = string(any, key: "url")
    guard !imageURL.isEmpty, let url = URL(string: imageURL) else { return nil }
    return try? await URLSession.shared.data(from: url).0
  }
  
  private func minutes(from any: Any?) -> Int? {
    guard let string = any as? String else { return nil }
    return Duration.minutesFromISO8601(string)
  }
  
  private func servingsCount(from any: Any?) -> Int? {
    if let number = any as? Int {
      return number
    }
    let string = string(any)
    if !string.isEmpty, let match = string.firstMatch(of: /\d+/) {
      return Int(match.0)
    }
    return nil
  }
  
  private func flattenInstructions(from any: Any?) -> [String] {
    if let string = any as? String {
      return string
        .components(separatedBy: .newlines)
        .map { $0.trimmingCharacters(in: .whitespaces) }
        .filter { !$0.isEmpty }
    }
    if let array = any as? [Any] {
      return array.flatMap { node -> [String] in
        if let string = node as? String {
          return [string]
        }
        if let dict = node as? [String: Any] {
          if let type = dict["@type"] as? String, type == "HowToSection",
             let items = dict["itemListElement"] as? [Any] {
            return flattenInstructions(from: items)
          }
          if let text = dict["text"] as? String {
            return [text]
          }
        }
        return []
      }
    }
    return []
  }
}

private extension Duration {
  static func minutesFromISO8601(_ s: String) -> Int? {
    guard s.hasPrefix("P") else { return nil }
    let hours = Int(s.firstMatch(of: /(\d+)H/)?.1 ?? "") ?? 0
    let mins = Int(s.firstMatch(of: /(\d+)M/)?.1 ?? "") ?? 0
    let total = hours * 60 + mins
    return total > 0 ? total : nil
  }
}
