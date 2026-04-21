//
//  RecipeView.swift
//  RecipesApp
//
//  Created by Tomas Trujillo on 2026-04-06.
//

import SwiftUI
import SwiftData

private enum FocusFields: Hashable {
  case title
  case subtitle
  case component(Int)
  case ingredient(Int)
  case step(Int)
}

struct RecipeView: View {
  @Environment(\.dismiss) private var dismiss
  @State private var viewModel: RecipeViewModel
  @FocusState private var focusedField: FocusFields?

  init(viewModel: RecipeViewModel) {
    _viewModel = State(initialValue: viewModel)
  }

  var body: some View {
    NavigationStack {
      Form {
        detailsSection
        cookingInfoSection
        ingredientsSection
        
        Section {
          Button("Add Ingredient Section") {
            viewModel.components.append(Component(ingredients: [Ingredient.empty]))
          }
        }
        stepsSection
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button {
            dismiss()
          } label: {
            Image(systemName: "xmark")
          }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          Button {
            viewModel.save()
            dismiss()
          } label: {
            Image(systemName: "checkmark")
          }
        }
      }
      .toolbar {
        ToolbarItemGroup(placement: .keyboard) {
          Spacer()
          Button("Done") {
            focusedField = nil
          }
        }
      }
      .scrollDismissesKeyboard(.interactively)
      .navigationTitle(navTitle)
      .onAppear {
        focusedField = .title
      }
    }
  }
  
  var navTitle: String {
    switch viewModel.mode {
    case .creating:
      "New Recipe"
    case .editing(let recipe):
      recipe.title
    }
  }

  private var detailsSection: some View {
    Section("Details") {
      TextField("Title", text: $viewModel.title)
        .focused($focusedField, equals: .title)
        .onSubmit {
          focusedField = .subtitle
        }
      TextField("Subtitle", text: $viewModel.subtitle)
        .focused($focusedField, equals: .subtitle)
    }
  }

  private var cookingInfoSection: some View {
    Section("Cooking Info") {
      Stepper(
        "Cook Time: \(viewModel.cookTime) min",
        value: $viewModel.cookTime,
        in: 0...480,
        step: 5
      )
      Stepper(
        "Servings: \(viewModel.servings)",
        value: $viewModel.servings,
        in: 1...20
      )
    }
  }

  private var ingredientsSection: some View {
    ForEach(viewModel.components.indices, id: \.self) { componentIndex in
      @Bindable var component = viewModel.components[componentIndex]
      Section(component.title.isEmpty ? "Ingredients" : component.title) {
        TextField("Title (Optional)", text: $component.title)
          .focused($focusedField, equals: .component(componentIndex))
        ForEach(component.ingredients.indices, id: \.self) { ingredientIndex in
          IngredientRowView(ingredient: component.ingredients[ingredientIndex])
            .focused($focusedField, equals: .ingredient(ingredientIndex))
            .onSubmit {
              guard ingredientIndex < component.ingredients.count - 1 else {
                focusedField = nil
                return
              }
              focusedField = .ingredient(ingredientIndex + 1)
            }
        }
        .onDelete { indices in
          viewModel.components[componentIndex].ingredients.remove(atOffsets: indices)
        }
        .onMove { from, to in
          viewModel.components[componentIndex].ingredients.move(fromOffsets: from, toOffset: to)
        }
        
        Button("Add Ingredient") {
          let ingredient = Ingredient.empty
          if viewModel.components.isEmpty {
            viewModel.components.append(Component(ingredients: [ingredient]))
          } else {
            viewModel.components[viewModel.components.count - 1].ingredients.append(ingredient)
          }
        }
        
      }
    }
  }
  
  private var stepsSection: some View {
    Section("Steps") {
      ForEach(viewModel.steps.indices, id: \.self) { index in
        @Bindable var step = viewModel.steps[index]
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
          guard index < viewModel.steps.count - 1 else {
            focusedField = nil
            return
          }
          focusedField = .step(index + 1)
        }
      }
      .onDelete { indices in
        viewModel.steps.remove(atOffsets: indices)
      }
      .onMove { from, to in
        viewModel.steps.move(fromOffsets: from, toOffset: to)
      }

      Button("Add Step") {
        viewModel.steps.append(.init(text: ""))
      }
    }
  }
}

#Preview {
  let config = ModelConfiguration(isStoredInMemoryOnly: true)
  let container = try! ModelContainer(for: Recipe.self, configurations: config)
  let recipe = Recipe.samples[0]
  container.mainContext.insert(recipe)
  return RecipeView(viewModel: RecipeViewModel(recipe: recipe, context: container.mainContext))
    .modelContainer(container)
}
