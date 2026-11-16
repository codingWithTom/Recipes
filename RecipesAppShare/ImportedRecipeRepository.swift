//
//  ImportedRecipeRepository.swift
//  RecipesApp
//
//  Created by Tomas Trujillo on 2026-05-11.
//

import Foundation

struct ImportedRecipeRepository {
  static let key = "pendingImport"
  static let suite = "group.CodingWithTom.Recipes"
  
  static func write(_ importedRecipe: ImportedRecipe) {
    guard let data = try? JSONEncoder().encode(importedRecipe) else { return }
    UserDefaults(suiteName: suite)?.set(data, forKey: key)
  }
  
  static func load() -> ImportedRecipe? {
    guard let data = UserDefaults(suiteName: suite)?.data(forKey: key) else { return nil }
    return try? JSONDecoder().decode(ImportedRecipe.self, from: data)
  }
  
  static func clear() {
    UserDefaults(suiteName: suite)?.removeObject(forKey: key)
  }
}
