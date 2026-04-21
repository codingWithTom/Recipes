//
//  RecipeDetailView.swift
//  RecipesApp
//
//  Created by Tomas Trujillo on 2026-03-29.
//

import SwiftUI

struct RecipeDetailView: View {
  let recipe: Recipe
  let namespace: Namespace.ID
  let onDismiss: () -> Void
  @State private var areStepsCollapsed = false

  var body: some View {
    ZStack(alignment: .topLeading) {
      ScrollView {
        VStack(alignment: .leading) {
          heroSection
          detailsSection
          Spacer()
            .frame(height: 60)
        }
      }
      dismissButton
    }
    .background(.regularMaterial)
    .ignoresSafeArea()
  }

  private var heroSection: some View {
    ZStack(alignment: .bottomLeading) {
      RoundedRectangle(cornerRadius: 24)
        .fill(.ultraThinMaterial)
        .matchedGeometryEffect(id: "card-\(recipe.id)", in: namespace, isSource: false)
        .frame(height: 360)
        .overlay(alignment: .center) {
          Image(systemName: recipe.imageName)
            .font(.system(size: 100))
            .matchedGeometryEffect(id: "icon-\(recipe.id)", in: namespace, isSource: false)
            .foregroundStyle(.secondary)
        }

      VStack(alignment: .leading, spacing: 4) {
        Text(recipe.title)
          .font(.title.bold())
          .matchedGeometryEffect(id: "title-\(recipe.id)", in: namespace, isSource: false)
        Text(recipe.subtitle)
          .font(.subheadline)
          .foregroundStyle(.secondary)
          .matchedGeometryEffect(id: "subtitle-\(recipe.id)", in: namespace, isSource: false)
      }
      .padding(24)
    }
    .padding(.bottom)
  }

  private var detailsSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      cookingInfo
      ingredientsSection
      stepsSection
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, 16)
  }

  private var cookingInfo: some View {
    HStack(spacing: 24) {
      Label("\(recipe.cookTime) min", systemImage: "clock")
        .font(.subheadline)
      Label("\(recipe.servings) servings", systemImage: "person.2")
        .font(.subheadline)
    }
    .padding(.top, 20)
  }

  private var ingredientsSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Ingredients")
        .font(.title2.bold())

      VStack(alignment: .leading, spacing: 8) {
        ForEach(recipe.components) { component in
          if !component.title.isEmpty {
            Text(component.title)
              .font(.title3.italic())
          }

          ForEach(component.ingredients) { ingredient in
            IngredientRow(ingredient: ingredient)
          }
        }
      }
    }
  }
  
  private var stepsSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      HStack {
        Text("Steps")
          .font(.title3.bold())

        Spacer()
        
        Button(action: { withAnimation { self.areStepsCollapsed.toggle() } }) {
          Text(areStepsCollapsed ? "Expand All" : "Collapse All")
        }
      }
      
      VStack(alignment: .leading, spacing: 16) {
        ForEach(recipe.steps.enumerated(), id: \.offset) { (index, step) in
          RecipeStepView(number: (index + 1), step: step, parentIsExpanded: !areStepsCollapsed)
          
          if (index + 1) < recipe.steps.count {          
            Divider()
          }
        }
      }
    }
  }

  private var dismissButton: some View {
    Button {
      onDismiss()
    } label: {
      Image(systemName: "xmark.circle.fill")
        .font(.largeTitle)
        .symbolRenderingMode(.hierarchical)
        .foregroundStyle(.secondary)
    }
    .padding(.top, 20)
    .padding(24)
  }
}

#Preview {
  @Previewable @Namespace var namespace
  RecipeDetailView(recipe: Recipe.samples[1], namespace: namespace) { }
}
