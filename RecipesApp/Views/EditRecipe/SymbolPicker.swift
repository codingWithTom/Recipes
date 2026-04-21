//
//  SymbolPicker.swift
//  RecipesApp
//
//  Created by Tomas Trujillo on 2026-04-19.
//

import SwiftUI

struct SymbolPicker: View {
  @Binding var selection: String
  @State private var search = ""
  @Environment(\.dismiss) private var dismiss

  let symbols = [
    "fork.knife", "cup.and.saucer", "flame",
    "leaf", "carrot", "fish", "birthday.cake",
    "takeoutbag.and.cup.and.straw", "frying.pan",
    "oven", "refrigerator", "waterbottle",
    // Fruits & Vegetables
    "applelogo", "leaf.fill", "leaf.arrow.circlepath",
    // Drinks
    "wineglass", "wineglass.fill", "mug", "mug.fill",
    "cup.and.saucer.fill", "waterbottle.fill", "drop", "drop.fill",
    // Kitchen tools & appliances
    "frying.pan.fill", "oven.fill", "microwave", "microwave.fill",
    "refrigerator.fill", "dishwasher", "dishwasher.fill",
    "cooktop", "cooktop.fill", "sink", "sink.fill",
    "popcorn", "popcorn.fill",
    // Food & cooking actions
    "flame.fill", "thermometer.medium", "timer", "timer.square",
    "cart", "cart.fill", "bag", "bag.fill",
    "tray", "tray.fill", "archivebox", "archivebox.fill",
    // Misc food-related
    "birthday.cake.fill",
    "fork.knife.circle", "fork.knife.circle.fill",
    "cup.and.heat.waves", "cup.and.heat.waves.fill",
    "bonjour", "allergens", "allergens.fill",
    "dumbbell", "heart", "heart.fill",
    "star", "star.fill", "checkmark.seal", "checkmark.seal.fill"
  ]

  var filtered: [String] {
    search.isEmpty ? symbols : symbols.filter { $0.contains(search.lowercased()) }
  }

  var body: some View {
    NavigationStack {
      ScrollView {
        LazyVGrid(
          columns: [.init(.adaptive(minimum: 60))],
          spacing: 16
        ) {
          ForEach(filtered, id: \.self) { name in
            Image(systemName: name)
              .font(.title)
              .frame(width: 60, height: 60)
              .background(
                selection == name ?
                Color.accentColor.opacity(0.1) : .clear,
                in: .rect(cornerRadius: 12)
              )
              .onTapGesture {
                selection = name
                dismiss()
              }
          }
        }
      }
      .searchable(text: $search, prompt: "Search symbols")
      .navigationTitle("Pick an Icon")
    }
  }
}
