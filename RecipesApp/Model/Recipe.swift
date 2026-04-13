//
//  Recipe.swift
//  RecipesApp
//
//  Created by Tomas Trujillo on 2026-03-18.
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

struct Ingredient: Identifiable, Hashable {
  let id = UUID()
  var name: String
  var icon: String
  var unit: String
  var quantity: String
}

extension Ingredient {
  static var empty: Ingredient {
    Ingredient(name: "", icon: "", unit: "", quantity: "0")
  }
}

struct Component: Identifiable, Hashable {
  let id = UUID()
  var title: String?
  var ingredients: [Ingredient]
}

struct Step: Identifiable, Hashable {
  let id = UUID()
  var text: String
  var ingredients: [Ingredient]
}

struct Recipe: Identifiable, Hashable {
  let id = UUID()
  var title: String
  var subtitle: String
  var imageName: String
  var cookTime: Int
  var servings: Int
  var components: [Component]
  var steps: [Step]
}

extension Recipe {
  static var empty: Recipe {
    Recipe(title: "", subtitle: "", imageName: "", cookTime: 0, servings: 0, components: [], steps: [])
  }
}

extension Recipe {
  static var samples: [Recipe] {
    [
      {
        let avocado = Ingredient(name: "Avocado", icon: "leaf.fill", unit: "", quantity: "1")
        let sourdough = Ingredient(name: "Sourdough bread", icon: "basket.fill", unit: "slices", quantity: "2")
        let oliveOil = Ingredient(name: "Olive oil", icon: "drop.fill", unit: "tbsp", quantity: "1")
        let salt = Ingredient(name: "Salt", icon: "diamond.fill", unit: "pinch", quantity: "1")
        let redPepperFlakes = Ingredient(name: "Red pepper flakes", icon: "flame.fill", unit: "pinch", quantity: "1")
        return Recipe(
          title: "Avocado Toast",
          subtitle: "Crispy sourdough with creamy avocado",
          imageName: "fork.knife",
          cookTime: 10,
          servings: 1,
          components: [
            Component(title: nil, ingredients: [avocado, sourdough, oliveOil, salt, redPepperFlakes])
          ],
          steps: [
            Step(text: "Toast the sourdough bread until golden and crispy.", ingredients: [sourdough]),
            Step(text: "Cut the avocado in half, remove the pit, and mash the flesh in a bowl.", ingredients: [avocado]),
            Step(text: "Drizzle olive oil over the toast and spread the mashed avocado on top.", ingredients: [oliveOil, avocado]),
            Step(text: "Season with salt and red pepper flakes.", ingredients: [salt, redPepperFlakes]),
          ]
        )
      }(),
      {
        let romaine = Ingredient(name: "Romaine lettuce", icon: "leaf.fill", unit: "heads", quantity: "2")
        let chicken = Ingredient(name: "Chicken breast", icon: "fork.knife", unit: "lbs", quantity: "1")
        let parmesan = Ingredient(name: "Parmesan cheese", icon: "triangle.fill", unit: "cup", quantity: "1/2")
        let croutons = Ingredient(name: "Croutons", icon: "square.grid.2x2", unit: "cup", quantity: "1")
        let caesarDressing = Ingredient(name: "Caesar dressing", icon: "drop.fill", unit: "tbsp", quantity: "3")
        return Recipe(
          title: "Chicken Caesar Salad",
          subtitle: "Classic romaine with grilled chicken",
          imageName: "leaf",
          cookTime: 20,
          servings: 2,
          components: [
            Component(title: "Salad", ingredients: [romaine, chicken, parmesan, croutons]),
            Component(title: "Dressing", ingredients: [caesarDressing])
          ],
          steps: [
            Step(text: "Grill the chicken breast until cooked through, then slice.", ingredients: [chicken]),
            Step(text: "Chop the romaine lettuce and place in a large bowl.", ingredients: [romaine]),
            Step(text: "Add sliced chicken, croutons, and parmesan on top.", ingredients: [chicken, croutons, parmesan]),
            Step(text: "Drizzle with Caesar dressing and toss to combine.", ingredients: [caesarDressing]),
          ]
        )
      }(),
      {
        let spaghetti = Ingredient(name: "Spaghetti", icon: "fork.knife", unit: "lbs", quantity: "1")
        let pancetta = Ingredient(name: "Pancetta", icon: "rectangle.fill", unit: "oz", quantity: "6")
        let eggs = Ingredient(name: "Eggs", icon: "oval.fill", unit: "", quantity: "3")
        let pecorino = Ingredient(name: "Pecorino Romano", icon: "triangle.fill", unit: "cup", quantity: "1")
        let blackPepper = Ingredient(name: "Black pepper", icon: "sparkle", unit: "tsp", quantity: "1")
        return Recipe(
          title: "Pasta Carbonara",
          subtitle: "Creamy egg-based pasta with pancetta",
          imageName: "flame",
          cookTime: 25,
          servings: 4,
          components: [
            Component(title: "Pasta", ingredients: [spaghetti]),
            Component(title: "Sauce", ingredients: [pancetta, eggs, pecorino, blackPepper])
          ],
          steps: [
            Step(text: "Cook spaghetti in salted boiling water until al dente.", ingredients: [spaghetti]),
            Step(text: "Crisp the pancetta in a pan over medium heat.", ingredients: [pancetta]),
            Step(text: "Whisk together eggs and pecorino in a bowl.", ingredients: [eggs, pecorino]),
            Step(text: "Toss hot pasta with pancetta, then stir in the egg mixture off heat.", ingredients: [spaghetti, pancetta]),
            Step(text: "Season generously with black pepper.", ingredients: [blackPepper]),
          ]
        )
      }(),
      {
        let darkChocolate = Ingredient(name: "Dark chocolate", icon: "square.fill", unit: "oz", quantity: "6")
        let butter = Ingredient(name: "Butter", icon: "rectangle.fill", unit: "tbsp", quantity: "4")
        let eggs = Ingredient(name: "Eggs", icon: "oval.fill", unit: "", quantity: "2")
        let sugar = Ingredient(name: "Sugar", icon: "cube.fill", unit: "cup", quantity: "1/4")
        let flour = Ingredient(name: "Flour", icon: "circle.fill", unit: "tbsp", quantity: "2")
        return Recipe(
          title: "Chocolate Lava Cake",
          subtitle: "Warm molten center with a crisp shell",
          imageName: "birthday.cake",
          cookTime: 30,
          servings: 2,
          components: [
            Component(title: nil, ingredients: [darkChocolate, butter, eggs, sugar, flour])
          ],
          steps: [
            Step(text: "Melt the dark chocolate and butter together.", ingredients: [darkChocolate, butter]),
            Step(text: "Whisk eggs and sugar until thick and pale.", ingredients: [eggs, sugar]),
            Step(text: "Fold the chocolate mixture into the eggs, then gently fold in flour.", ingredients: [flour]),
            Step(text: "Pour into greased ramekins and bake at 425°F for 12 minutes.", ingredients: []),
          ]
        )
      }(),
      {
        let mixedBerries = Ingredient(name: "Mixed berries", icon: "leaf.fill", unit: "cup", quantity: "2")
        let acaiPacket = Ingredient(name: "Acai packet", icon: "bag.fill", unit: "", quantity: "1")
        let banana = Ingredient(name: "Banana", icon: "moon.fill", unit: "", quantity: "1")
        let granola = Ingredient(name: "Granola", icon: "cup.and.saucer.fill", unit: "cup", quantity: "1/2")
        let honey = Ingredient(name: "Honey", icon: "drop.fill", unit: "tbsp", quantity: "1")
        return Recipe(
          title: "Berry Smoothie Bowl",
          subtitle: "Frozen berries blended with acai",
          imageName: "cup.and.saucer",
          cookTime: 5,
          servings: 1,
          components: [
            Component(title: "Base", ingredients: [mixedBerries, acaiPacket, banana]),
            Component(title: "Toppings", ingredients: [granola, honey])
          ],
          steps: [
            Step(text: "Blend frozen berries, acai packet, and half the banana until smooth.", ingredients: [mixedBerries, acaiPacket, banana]),
            Step(text: "Pour into a bowl and top with granola, remaining berries, and a drizzle of honey.", ingredients: [granola, mixedBerries, honey]),
          ]
        )
      }(),
      {
        let salmon = Ingredient(name: "Salmon fillet", icon: "fish.fill", unit: "oz", quantity: "12")
        let lemon = Ingredient(name: "Lemon", icon: "circle.fill", unit: "", quantity: "1")
        let butter = Ingredient(name: "Butter", icon: "rectangle.fill", unit: "tbsp", quantity: "2")
        let garlic = Ingredient(name: "Garlic", icon: "sparkle", unit: "cloves", quantity: "3")
        let dill = Ingredient(name: "Fresh dill", icon: "leaf.fill", unit: "sprigs", quantity: "3")
        return Recipe(
          title: "Grilled Salmon",
          subtitle: "Pan-seared with lemon butter glaze",
          imageName: "fish",
          cookTime: 18,
          servings: 2,
          components: [
            Component(title: nil, ingredients: [salmon, lemon, butter, garlic, dill])
          ],
          steps: [
            Step(text: "Season the salmon fillet with salt and pepper.", ingredients: [salmon]),
            Step(text: "Sear salmon skin-side down in a hot pan for 4 minutes.", ingredients: [salmon]),
            Step(text: "Flip and cook for another 3 minutes.", ingredients: []),
            Step(text: "Melt butter with garlic and lemon juice, then pour over the salmon.", ingredients: [butter, garlic, lemon]),
            Step(text: "Garnish with fresh dill.", ingredients: [dill]),
          ]
        )
      }(),
    ]
  }
}
