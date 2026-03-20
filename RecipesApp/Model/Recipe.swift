//
//  Recipe.swift
//  RecipesApp
//
//  Created by Tomas Trujillo on 2026-03-18.
//

import Foundation

struct Recipe: Identifiable, Hashable {
  let id = UUID()
  let title: String
  let subtitle: String
  let imageName: String
  let cookTime: Int
  let servings: Int
  let category: RecipeCategory
}

enum RecipeCategory: String, CaseIterable {
  case breakfast
  case lunch
  case dinner
  case dessert
}

extension Recipe {
  static var samples: [Recipe] {
    [
      Recipe(title: "Avocado Toast", subtitle: "Crispy sourdough with creamy avocado", imageName: "fork.knife", cookTime: 10, servings: 1, category: .breakfast),
      Recipe(title: "Chicken Caesar Salad", subtitle: "Classic romaine with grilled chicken", imageName: "leaf", cookTime: 20, servings: 2, category: .lunch),
      Recipe(title: "Pasta Carbonara", subtitle: "Creamy egg-based pasta with pancetta", imageName: "flame", cookTime: 25, servings: 4, category: .dinner),
      Recipe(title: "Chocolate Lava Cake", subtitle: "Warm molten center with a crisp shell", imageName: "birthday.cake", cookTime: 30, servings: 2, category: .dessert),
      Recipe(title: "Berry Smoothie Bowl", subtitle: "Frozen berries blended with acai", imageName: "cup.and.saucer", cookTime: 5, servings: 1, category: .breakfast),
      Recipe(title: "Grilled Salmon", subtitle: "Pan-seared with lemon butter glaze", imageName: "fish", cookTime: 18, servings: 2, category: .dinner),
      
    ]
  }
}
