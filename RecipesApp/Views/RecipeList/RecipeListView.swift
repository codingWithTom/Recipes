//
//  RecipeListView.swift
//  RecipesApp
//
//  Created by Tomas Trujillo on 2026-03-18.
//

import SwiftUI
import SwiftData

struct RecipeListView: View {
  @Query(sort: \Recipe.dateAdded, order: .reverse)
  private var recipes: [Recipe]
  @Environment(\.modelContext) private var context
  
  @Binding var selectedRecipe: Recipe?
  let namespace: Namespace.ID
  @State private var isPresentingNewRecipe = false
  @State private var editingRecipe: Recipe?

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
                .contextMenu {
                  Button("Edit", systemImage: "pencil") {
                    editingRecipe = recipe
                  }

                  Button("Delete", systemImage: "trash", role: .destructive) {
                    context.delete(recipe)
                  }
                }
            }
          }
        }
        .padding()
      }
      .navigationTitle("Recipes")
      .sheet(isPresented: $isPresentingNewRecipe) {
        EditRecipeView(viewModel: RecipeViewModel(context: context))
      }
      .sheet(item: $editingRecipe) { recipe in
        EditRecipeView(viewModel: .init(recipe: recipe, context: context))
      }
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button {
            isPresentingNewRecipe = true
          } label: {
            Image(systemName: "plus")
          }
        }
      }
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
          RecipeImage(recipe: recipe, fontSize: 80, cornerRadius: 24)
            .matchedGeometryEffect(id: "icon-\(recipe.id)", in: namespace)
        }
      
      VStack(alignment: .leading, spacing: 4) {
        Text(recipe.title)
          .font(.title2.bold())
          .matchedGeometryEffect(id: "title-\(recipe.id)", in: namespace)
          .foregroundStyle(.white)
        Text(recipe.subtitle)
          .font(.subheadline)
          .foregroundStyle(.white.opacity(0.85))
          .matchedGeometryEffect(id: "subtitle-\(recipe.id)", in: namespace)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(20)
      .background(
        LinearGradient(
          colors: [.clear, .black.opacity(0.6)],
          startPoint: .top,
          endPoint: .bottom
        )
      )
      .clipShape(
        UnevenRoundedRectangle(
          topLeadingRadius: 0,
          bottomLeadingRadius: 24,
          bottomTrailingRadius: 24,
          topTrailingRadius: 0
        )
      )
    }
  }
}

#Preview {
  let config = ModelConfiguration(isStoredInMemoryOnly: true)
  let container = try! ModelContainer(for: Recipe.self, configurations: config)
  for recipe in Recipe.samples {
    container.mainContext.insert(recipe)
  }
  return RecipeListView(selectedRecipe: .constant(nil), namespace: Namespace().wrappedValue)
    .modelContainer(container)
}
