//
//  ContentView.swift
//  RecipesApp
//
//  Created by Tomas Trujillo on 2026-03-18.
//

import SwiftUI

struct ContentView: View {
  @State private var selectedRecipe: Recipe?
  @Namespace var namespace
  var body: some View {
    TabView {
      Tab("Recipes", systemImage: "book") {
        RecipeListView(selectedRecipe: $selectedRecipe, namespace: namespace)
      }
      
      Tab("Favorites", systemImage: "heart") {
        Text("Favorites coming soon")
      }
    }
    .overlay {
      if let recipe = selectedRecipe {
        RecipeDetailView(
          recipe: recipe,
          namespace: namespace,
          onDismiss: {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
              self.selectedRecipe = nil
            }
          }
        )
        .zIndex(2)
      }
    }
  }
}

#Preview {
  ContentView()
}
