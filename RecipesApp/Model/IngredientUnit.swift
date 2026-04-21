//
//  IngredientUnit.swift
//  RecipesApp
//
//  Created by Tomas Trujillo on 2026-04-19.
//

import Foundation

enum IngredientUnit: CaseIterable, Hashable, CustomStringConvertible, Identifiable {
  case none
  case slices
  case tablespoon
  case teaspoon
  case pinch
  case cup
  case ounce
  case pound
  case head
  case clove
  case sprig
  
  var id: String { description }

  var description: String {
    switch self {
    case .none:       ""
    case .slices:     "slices"
    case .tablespoon: "tbsp"
    case .teaspoon:   "tsp"
    case .pinch:      "pinch"
    case .cup:        "cup"
    case .ounce:      "oz"
    case .pound:      "lbs"
    case .head:       "heads"
    case .clove:      "cloves"
    case .sprig:      "sprigs"
    }
  }
}
