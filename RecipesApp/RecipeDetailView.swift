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

  var body: some View {
    ZStack(alignment: .topLeading) {
      ScrollView {
        VStack(alignment: .leading) {
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
          
          VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 24) {
              Label("\(recipe.cookTime) min", systemImage: "clock")
                .font(.subheadline)
              Label("\(recipe.servings) servings", systemImage: "person.2")
                .font(.subheadline)
            }
            .padding(.top, 20)

            VStack(alignment: .leading, spacing: 8) {
              Text("Ingredients")
                .font(.headline)
              Text("Coming soon")
                .font(.subheadline)
                .foregroundStyle(.tertiary)
            }
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.horizontal, 16)

        }
      }
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
    .background(.regularMaterial)
    .ignoresSafeArea()
  }
}

#Preview {
  @Previewable @Namespace var namespace
  RecipeDetailView(recipe: Recipe.samples[0], namespace: namespace) { }
}
