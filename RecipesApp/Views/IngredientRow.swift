//
//  IngredientRow.swift
//  RecipesApp
//
//  Created by Tomas Trujillo on 2026-04-04.
//

import SwiftUI

struct IngredientRow: View {
  let ingredient: Ingredient
  
  var body: some View {
    HStack(spacing: 16) {
      Image(systemName: ingredient.icon)
        .font(.body)
        .frame(width: 36, height: 36)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .glassEffect(.regular.tint(.blue.opacity(0.05)))
      
      VStack(alignment: .leading) {
        Text(ingredient.name)
          .font(.subheadline.weight(.medium))
        
        Text("\(ingredient.quantity) \(Text(ingredient.unit).bold())")
          .font(.caption)
      }
      
      Spacer()
    }
  }
}

#Preview {
  let mixedBerries = Ingredient(name: "Mixed berries", icon: "leaf.fill", unit: "cups", quantity: "2")
  IngredientRow(ingredient: mixedBerries)
}
