//
//  RecipeView.swift
//  RecipesApp
//
//  Created by Tomas Trujillo on 2026-03-18.
//

import SwiftUI

struct RecipeView: View {
  let recipe: Recipe
  var body: some View {
    ZStack(alignment: .bottomTrailing) {
      ScrollView {
        VStack(alignment: .leading, spacing: 16) {
          Image(systemName: recipe.imageName)
            .font(.system(size: 60))
            .frame(maxWidth: .infinity, minHeight: 200)
            .background(.ultraThinMaterial)
            .glassEffect(.regular)
            .clipShape(RoundedRectangle(cornerRadius: 20))
          
          Spacer()
            .frame(height: 200)
          
          Text("\(recipe.subtitle) \(recipe.subtitle)")
            .font(.title3)
            .foregroundStyle(.secondary)
          
          HStack {
            Spacer()
            Label("\(recipe.cookTime) min", systemImage: "clock")
            Spacer()
            Label("\(recipe.servings) servings", systemImage: "person.2")
            Spacer()
          }
          
          Text("Ingredients! COMING SOON")
            .foregroundStyle(.tertiary)
        }
        .padding()
      }
      
      Button(action: {}) {
        Image(systemName: "heart.fill")
      }
      .tint(.red)
      .buttonStyle(.glass)
      .padding(20)
    }
    .navigationTitle(recipe.title)
    .navigationBarTitleDisplayMode(.large)
  }
}

#Preview {
  NavigationStack {
    RecipeView(recipe: .init(title: "Avocado Toast", subtitle: "Crispy sourdough with creamy avocado", imageName: "fork.knife", cookTime: 10, servings: 1, category: .breakfast))
  }
}
