//
//  RecipeView.swift
//  RecipesApp
//
//  Created by Tomas Trujillo on 2026-04-06.
//

import SwiftUI

private enum FocusFields: Hashable {
  case title
  case subtitle
  case ingredient(Int)
  case step(Int)
}

struct RecipeView: View {
  let recipe: Recipe
  @State private var title = ""
  @State private var subtitle = ""
  @State private var cookTime = 15
  @State private var servings = 2
  @State private var ingredients: [Ingredient] = []
  @State private var steps: [Step] = []
  @FocusState private var focusedField: FocusFields?
  
  var body: some View {
    NavigationStack {
      Form {
        detailsSection
        cookingInfoSection
        ingredientsSection
        stepsSection
      }
      .toolbar { EditButton() }
      .toolbar {
        ToolbarItemGroup(placement: .keyboard) {
          Spacer()
          Button("Done") {
            focusedField = nil
          }
        }
      }
      .scrollDismissesKeyboard(.interactively)
      .navigationTitle(recipe.title.isEmpty ? "New Recipe" : recipe.title)
      .onAppear {
        focusedField = .title
      }
    }
  }

  private var detailsSection: some View {
    Section("Details") {
      TextField("Title", text: $title)
        .focused($focusedField, equals: .title)
        .onSubmit {
          focusedField = .subtitle
        }
      TextField("Subtitle", text: $subtitle)
        .focused($focusedField, equals: .subtitle)
    }
  }

  private var cookingInfoSection: some View {
    Section("Cooking Info") {
      Stepper(
        "Cook Time: \(cookTime) min",
        value: $cookTime,
        in: 0...480,
        step: 5
      )
      Stepper(
        "Servings: \(servings)",
        value: $servings,
        in: 1...20
      )
    }
  }

  private var ingredientsSection: some View {
    Section("Ingredients") {
      ForEach($ingredients.enumerated(), id: \.element.id) { index, $ingredient in
        IngredientRowView(ingredient: $ingredient)
          .focused($focusedField, equals: .ingredient(index))
          .onSubmit {
            guard index < ingredients.count - 1 else {
              focusedField = nil
              return
            }
            focusedField = .ingredient(index + 1)
          }
      }
      .onDelete { indices in
        ingredients.remove(atOffsets: indices)
      }
      .onMove { from, to in
        ingredients.move(fromOffsets: from, toOffset: to)
      }

      Button("Add Ingredient") {
        ingredients.append(.empty)
      }
    }
  }

  private var stepsSection: some View {
    Section("Steps") {
      ForEach($steps.enumerated(), id: \.element.id) {
        index,
        $step in
        HStack {
          Text("\(index + 1)")
            .foregroundStyle(.secondary)
          TextField(
            "Describe cooking step",
            text: $step.text,
            axis: .vertical
          )
        }
        .focused($focusedField, equals: .step(index))
        .onSubmit {
          guard index < steps.count - 1 else {
            focusedField = nil
            return
          }
          focusedField = .step(index + 1)
        }
      }
      .onDelete { indices in
        steps.remove(atOffsets: indices)
      }
      .onMove { from, to in
        steps.move(fromOffsets: from, toOffset: to)
      }

      Button("Add Step") {
        steps.append(.init(text: "", ingredients: []))
      }
    }
  }
}

private struct IngredientRowView: View {
  @Binding var ingredient: Ingredient
  @State private var iconName: String = "leaf"
  @State private var wholeQuantity = ""
  @State private var fractionQuantity = ""
  @State private var unit = ""
  @State private var isPresentingIconPicker = false
  
  private let fractions = [
    "",
    "1/8",
    "1/4",
    "1/3",
    "1/2",
    "2/3",
    "3/4"
  ]
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Image(systemName: iconName)
          .foregroundStyle(.blue)
          .onTapGesture {
            withAnimation { isPresentingIconPicker.toggle() }
          }
        TextField("Ingredient name", text: $ingredient.name)
      }
      
      Text("Quantity")
        .font(.body.bold())
      
      HStack {
        PickerTextfield(
          placeholder: "Ingredient unit",
          options: Array(0...20).map { "\($0)" },
          value: $wholeQuantity)
        
        PickerTextfield(
          placeholder: "Fractions",
          options: fractions,
          value: $fractionQuantity
        )
        
        PickerTextfield(
          placeholder: "Unit",
          options: IngredientUnit.allCases.map { $0.description },
          value: $unit
        )
      }
    }
    .padding(.vertical, 4)
    .sheet(isPresented: $isPresentingIconPicker) {
      SymbolPicker(selection: $iconName)
    }
  }
}

#Preview {
  NavigationStack {
    RecipeView(recipe: Recipe.samples[0])
  }
}


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
