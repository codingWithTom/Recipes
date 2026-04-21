//
//  IngredientRowView.swift
//  RecipesApp
//
//  Created by Tomas Trujillo on 2026-04-19.
//

import SwiftUI
import Observation

@Observable
final class IngredientRowViewModel {
  var wholeQuantity = ""
  var fractionQuantity = ""

  var ingredient: Ingredient
  let fractions = [
    "1/8",
    "1/4",
    "1/3",
    "1/2",
    "2/3",
    "3/4"
  ]

  init(ingredient: Ingredient) {
    self.ingredient = ingredient
    parseQuantity(ingredient.quantity)
  }

  func updateQuantity() {
    if fractionQuantity.isEmpty {
      ingredient.quantity = wholeQuantity
    } else if wholeQuantity == "0" || wholeQuantity.isEmpty {
      ingredient.quantity = fractionQuantity
    } else {
      ingredient.quantity = "\(wholeQuantity) \(fractionQuantity)"
    }
  }

  private func parseQuantity(_ quantity: String) {
    let parts = quantity.split(separator: " ", maxSplits: 1)
    if parts.count == 2 {
      wholeQuantity = String(parts[0])
      fractionQuantity = String(parts[1])
    } else if let part = parts.first {
      let str = String(part)
      if fractions.contains(str) {
        wholeQuantity = "0"
        fractionQuantity = str
      } else {
        wholeQuantity = str
        fractionQuantity = ""
      }
    }
  }
}

struct IngredientRowView: View {
  @State private var viewModel: IngredientRowViewModel
  @State private var isPresentingIconPicker = false

  init(ingredient: Ingredient) {
    self._viewModel = State(wrappedValue: IngredientRowViewModel(ingredient: ingredient))
  }

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Image(systemName: viewModel.ingredient.icon.isEmpty ? "leaf" : viewModel.ingredient.icon)
          .foregroundStyle(.blue)
          .onTapGesture {
            withAnimation { isPresentingIconPicker.toggle() }
          }
        TextField("Ingredient name", text: $viewModel.ingredient.name)
      }

      Text("Quantity")
        .font(.body.bold())

      HStack {
        PickerTextfield(
          placeholder: "Whole",
          options: Array(0...20).map { "\($0)" },
          value: $viewModel.wholeQuantity
        )

        PickerTextfield(
          placeholder: "Fraction",
          options: viewModel.fractions,
          value: $viewModel.fractionQuantity
        )

        PickerTextfield(
          placeholder: "Unit",
          options: IngredientUnit.allCases.map { $0.description },
          value: $viewModel.ingredient.unit
        )
      }
    }
    .padding(.vertical, 4)
    .onChange(of: viewModel.wholeQuantity) { viewModel.updateQuantity() }
    .onChange(of: viewModel.fractionQuantity) { viewModel.updateQuantity() }
    .sheet(isPresented: $isPresentingIconPicker) {
      SymbolPicker(selection: $viewModel.ingredient.icon)
    }
  }
}

#Preview {
  let ingredient = Ingredient(name: "Avocado", icon: "leaf.fill", unit: "cup", quantity: "1 1/2")
  return Form {
    IngredientRowView(ingredient: ingredient)
  }
}
