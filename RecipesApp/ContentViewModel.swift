//
//  ContentViewModel.swift
//  RecipesApp
//
//  Created by Tomas Trujillo on 2026-05-12.
//

import Foundation
import Observation

@Observable
final class ContentViewModel {
  var importedRecipe: ImportedRecipe?
  
  func onAppear() async {
    if let importRecipe = ImportedRecipeRepository.load() {
      self.importedRecipe = importRecipe
    }
  }
}
