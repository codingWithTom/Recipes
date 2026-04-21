//
//  RecipeViewModel.swift
//  RecipesApp
//
//  Created by Tomas Trujillo on 2026-04-19.
//

import Foundation
import SwiftData
import Observation

@Observable
final class RecipeViewModel {
  enum Mode {
    case creating
    case editing(Recipe)
  }

  var title = ""
  var subtitle = ""
  var cookTime = 15
  var servings = 2
  var components: [Component] = []
  var steps: [Step] = []

  private(set) var mode: Mode
  let context: ModelContext

  init(recipe: Recipe? = nil, context: ModelContext) {
    self.context = context
    if let recipe {
      self.mode = .editing(recipe)
      self.title = recipe.title
      self.subtitle = recipe.subtitle
      self.cookTime = recipe.cookTime
      self.servings = recipe.servings
      self.components = recipe.components
      self.steps = recipe.steps
    } else {
      self.mode = .creating
    }
  }

  func save() {
    switch mode {
    case .creating:
      let imageName = ["fish", "cup.and.saucer", "birthday.cake", "flame", "leaf", "fork.knife"].randomElement()
      let recipe = Recipe(
        title: title,
        subtitle: subtitle,
        imageName: imageName ?? "",
        cookTime: cookTime,
        servings: servings,
        components: components,
        steps: steps
      )
      context.insert(recipe)
    case .editing(let recipe):
      recipe.title = title
      recipe.subtitle = subtitle
      recipe.cookTime = cookTime
      recipe.servings = servings
      recipe.components = components
      recipe.steps = steps
    }
  }
}
