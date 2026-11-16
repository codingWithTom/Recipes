//
//  ContentView.swift
//  RecipesApp
//
//  Created by Tomas Trujillo on 2026-03-18.
//

import SwiftData
import SwiftUI

struct ContentView: View {
  @State private var selectedRecipe: Recipe?
  @State private var viewModel: ContentViewModel
  @Environment(\.modelContext) private var context

  @Namespace var namespace
  init() {
    _viewModel = State(initialValue: ContentViewModel())
  }
  var body: some View {
    TabView {
      Tab("Recipes", systemImage: "book") {
        RecipeListView(selectedRecipe: $selectedRecipe, namespace: namespace)
      }

      Tab("Favorites", systemImage: "heart") {
        Text("Favorites coming soon")
      }
    }
    .task { await viewModel.onAppear() }
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
    .sheet(item: $viewModel.importedRecipe) {
      EditRecipeView(viewModel: .init(importedRecipe: $0, context: context))
    }
  }
}

#Preview {
  ContentView()
}
