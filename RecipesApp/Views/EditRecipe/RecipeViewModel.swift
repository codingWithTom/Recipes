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
    case importing
    case editing(Recipe)
  }

  var title = ""
  var subtitle = ""
  var imageData: Data?
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
      self.imageData = recipe.imageData
      self.cookTime = recipe.cookTime
      self.servings = recipe.servings
      self.components = recipe.components
      self.steps = recipe.steps
    } else {
      self.mode = .creating
    }
  }
  
  init(importedRecipe: ImportedRecipe, context: ModelContext) {
    self.title = importedRecipe.title
    self.subtitle = importedRecipe.subtitle
    self.imageData = importedRecipe.imageData
    self.cookTime = importedRecipe.cookTime
    self.servings = importedRecipe.servings
    self.components = importedRecipe.components.map { Component(from: $0) }
    self.steps = importedRecipe.steps.map { Step(text: $0.text) }
    self.context = context
    self.mode = .importing
  }

  func save() {
    switch mode {
    case .creating, .importing:
      let imageName = ["fish", "cup.and.saucer", "birthday.cake", "flame", "leaf", "fork.knife"].randomElement()
      let recipe = Recipe(
        title: title,
        subtitle: subtitle,
        imageName: imageName ?? "",
        imageData: imageData,
        cookTime: cookTime,
        servings: servings,
        components: components,
        steps: steps
      )
      context.insert(recipe)
    case .editing(let recipe):
      recipe.title = title
      recipe.subtitle = subtitle
      recipe.imageData = imageData
      recipe.cookTime = cookTime
      recipe.servings = servings
      recipe.components = components
      recipe.steps = steps
    }
  }
  
  func onImageUpdated(data: Data) {
    self.imageData = data
  }
  
  func removeImage() {
    self.imageData = nil
  }
}

extension Component {
  convenience init(from importedComponent: ImportedComponent) {
    self.init(
      title: importedComponent.title,
      ingredients: importedComponent.ingredients.map { Ingredient(from: $0) }
    )
  }
}

extension Ingredient {
  convenience init(from importedIngredient: ImportedIngredient) {
    self.init(
      name: importedIngredient.name,
      icon: "",
      unit: importedIngredient.unit,
      quantity: importedIngredient.quantity,
    )
  }
}
