//
//  RecipesAppApp.swift
//  RecipesApp
//
//  Created by Tomas Trujillo on 2026-03-18.
//

import SwiftUI
import SwiftData

@main
struct RecipesAppApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
    .modelContainer(for: Recipe.self)
  }
}
