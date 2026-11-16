//
//  ShareViewModel.swift
//  RecipesAppShare
//
//  Created by Tomas Trujillo on 2026-05-11.
//

import Foundation
import Observation

@Observable
final class ShareViewModel {
  struct Content {
    var imageData: Data?
    var title: String
    var description: String
    var cookingTime: Int
    var servings: Int
  }

  enum State {
    case loading
    case error
    case loaded(Content)
  }

  let url: URL
  let loadRecipeUseCase = LoadRecipeUseCase()
  private(set) var state: State = .loading
  private var importedRecipe: ImportedRecipe?

  init(url: URL) {
    self.url = url
  }

  func load() async {
    do {
      let recipe = try await loadRecipeUseCase.execute(url: url)
      importedRecipe = recipe
      state = .loaded(
        .init(
          imageData: recipe.imageData,
          title: recipe.title,
          description: recipe.subtitle,
          cookingTime: recipe.cookTime,
          servings: recipe.servings
        )
      )
    } catch {
      state = .error
    }
  }

  func confirm() async {
    guard let importedRecipe else { return }
    saveRecipe(importedRecipe: importedRecipe)
  }
  
  private func saveRecipe(importedRecipe: ImportedRecipe) {
    ImportedRecipeRepository.write(importedRecipe)
  }
}
