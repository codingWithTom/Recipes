//
//  ImportedRecipe.swift
//  RecipesAppShare
//
//  Created by Tomas Trujillo on 2026-05-11.
//

import Foundation

struct ImportedRecipe: Codable, Identifiable {
  var id: String { "\(title)\(subtitle)" }
  var title: String
  var subtitle: String
  var imageData: Data?
  var cookTime: Int
  var servings: Int
  var components: [ImportedComponent]
  var steps: [ImportedStep]
}

struct ImportedComponent: Codable {
  var title: String
  var ingredients: [ImportedIngredient]
}

struct ImportedIngredient: Codable {
  var name: String
  var icon: String
  var unit: String
  var quantity: String
}

struct ImportedStep: Codable {
  var text: String
}
