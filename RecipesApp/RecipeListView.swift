//
//  RecipeListView.swift
//  RecipesApp
//
//  Created by Tomas Trujillo on 2026-03-18.
//

import SwiftUI

struct RecipeListView: View {
  let recipes = Recipe.samples
  @Binding var selectedRecipe: Recipe?
  let namespace: Namespace.ID
  
  var body: some View {
    NavigationStack {
      ScrollView {
        LazyVStack(spacing: 20) {
          ForEach(recipes) { recipe in
            if selectedRecipe?.id != recipe.id {
              RecipeHeroCard(recipe: recipe, namespace: namespace)
                .onTapGesture {
                  withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
                    selectedRecipe = recipe
                  }
                }
            }
          }
        }
        .padding()
      }
      .navigationTitle("Recipes")
    }
  }
}

struct RecipeHeroCard: View {
  let recipe: Recipe
  let namespace: Namespace.ID
  
  var body: some View {
    ZStack(alignment: .bottomLeading) {
      RoundedRectangle(cornerRadius: 24)
        .fill(.ultraThinMaterial)
        .matchedGeometryEffect(id: "card-\(recipe.id)", in: namespace)
        .frame(height: 280)
        .overlay(alignment: .center) {
          Image(systemName: recipe.imageName)
            .font(.system(size: 80))
            .matchedGeometryEffect(id: "icon-\(recipe.id)", in: namespace)
            .foregroundStyle(.secondary)
          
        }
      
      VStack(alignment: .leading, spacing: 4) {
        Text(recipe.title)
          .font(.title2.bold())
          .matchedGeometryEffect(id: "title-\(recipe.id)", in: namespace)
        Text(recipe.subtitle)
          .font(.subheadline)
          .foregroundStyle(.secondary)
          .matchedGeometryEffect(id: "subtitle-\(recipe.id)", in: namespace)
      }
      .padding(20)
    }
    .glassEffect(.regular)
  }
}

#Preview {
  RecipeListView(selectedRecipe: .constant(nil), namespace: Namespace().wrappedValue)
}
