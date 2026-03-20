//
//  RecipeListView.swift
//  RecipesApp
//
//  Created by Tomas Trujillo on 2026-03-18.
//

import SwiftUI

struct RecipeListView: View {
  let recipes = Recipe.samples
  
  var body: some View {
    NavigationStack {
      List(recipes) { recipe in
        NavigationLink(value: recipe) {
          RecipeRow(recipe: recipe)
        }
      }
      .navigationTitle("Recipes")
      .navigationDestination(for: Recipe.self) { recipe in
        RecipeView(recipe: recipe)
      }
    }
  }
}

private struct RecipeRow: View {
  let recipe: Recipe
  
  var body: some View {
    HStack(spacing: 16) {
      Image(systemName: recipe.imageName)
        .font(.title2)
        .frame(width: 44, height: 44)
        .background(.ultraThinMaterial)
        .glassEffect(.regular.tint(.blue.opacity(0.2)))
        .clipShape(RoundedRectangle(cornerRadius: 16))
      
      VStack(alignment: .leading, spacing: 4) {
        Text(recipe.title)
          .font(.headline)
        Text(recipe.subtitle)
          .font(.subheadline)
          .foregroundStyle(.secondary)
      }
      
      Spacer()
      
      Text("\(recipe.cookTime) min")
        .font(.caption)
        .foregroundStyle(.secondary)
    }
  }
}

#Preview {
  RecipeListView()
}
