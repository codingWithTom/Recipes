//
//  ContentView.swift
//  RecipesApp
//
//  Created by Tomas Trujillo on 2026-03-18.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    TabView {
      Tab("Recipes", systemImage: "book") {
        RecipeListView()
      }
      
      Tab("Favorites", systemImage: "heart") {
        Text("Favorites coming soon")
      }
    }
  }
}

#Preview {
  ContentView()
}
