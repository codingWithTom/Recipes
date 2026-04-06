//
//  RecipeStepView.swift
//  RecipesApp
//
//  Created by Tomas Trujillo on 2026-04-04.
//

import SwiftUI

struct RecipeStepView: View {
  let number: Int
  let step: Step
  let parentIsExpanded: Bool
  @State private var isExpanded: Bool = true
  
  var body: some View {
    VStack(alignment: .leading) {
      Button {
        withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
          isExpanded.toggle()
        }
      } label: {
        HStack {
          Text("\(number)")
            .font(.headline)
          
          Spacer()
          
          Image(systemName: "chevron.down")
            .font(.caption.bold())
            .foregroundStyle(.secondary)
            .rotationEffect(.degrees(isExpanded ? 180 : 0))
        }
        .contentShape(Rectangle())
      }
      .buttonStyle(.plain)
      
      if isExpanded {
        Text(step.text)
          .font(.subheadline)
          .foregroundStyle(.primary)
          .transition(.opacity.combined(with: .move(edge: .bottom)))
          .padding(.top, 4)
      }
    }
    .onChange(of: parentIsExpanded) { _, newValue in
      withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
        isExpanded = newValue
      }
    }
  }
}

#Preview {
  let step = Step(text: "Pour into greased ramekins and bake at 425°F for 12 minutes.", ingredients: [])
  RecipeStepView(number: 1, step: step, parentIsExpanded: true)
    .padding()
}
