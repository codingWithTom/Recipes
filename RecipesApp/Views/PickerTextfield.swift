//
//  PickerTextfield.swift
//  RecipesApp
//
//  Created by Tomas Trujillo on 2026-04-13.
//

import SwiftUI

struct PickerTextfield: View {
  var placeholder: String
  let options: [String]
  @Binding var value: String
  
  @State private var selection: String = ""
  @State private var customText: String = ""
  @State private var isShowingTextField: Bool = false
  @FocusState private var isTextFieldFocused: Bool
  @State private var isFocused = false
  
  private let otherOption = "Other"
  var body: some View {
    HStack {
      if isShowingTextField {
        TextField(placeholder, text: $customText)
          .multilineTextAlignment(.leading)
          .focused($isTextFieldFocused)
          .onSubmit {
            value = customText
            isTextFieldFocused = false
          }
        
        Button {
          resetToPicker()
        } label: {
          Image(systemName: "xmark.circle.fill")
            .foregroundStyle(.tertiary)
        }
      } else {
        Picker("", selection: $selection) {
          Text(placeholder).tag("")
          
          Divider()
          Text(otherOption)
            .tag(otherOption)
          Divider()
          
          ForEach(options, id: \.self) { option in
            Text(option)
              .tag(option)
          }
        }
        .pickerStyle(.menu)
      }
    }
    .onChange(of: selection) { oldSelection, newSelection in
      if newSelection == otherOption {
        withAnimation(.easeOut(duration: 0.3)) {
          isShowingTextField = true
        }
        customText = ""
        isTextFieldFocused = true
        value = ""
      } else if !newSelection.isEmpty {
        value = newSelection
      }
    }
    .onChange(of: isTextFieldFocused) { oldFocus, newFocus in
      print("FOCUS CHANGED to \(newFocus)")
      if !newFocus && customText.isEmpty {
        resetToPicker()
      }
    }
    .onAppear {
      if options.contains(value) {
        selection = value
      } else if !value.isEmpty {
        isShowingTextField = true
        customText = value
      }
    }
  }
  
  private func resetToPicker() {
    withAnimation(.easeOut(duration: 0.3)) {
      isShowingTextField = false
    }
    customText = ""
    selection = ""
    value = ""
    isTextFieldFocused = false
  }
}

#Preview {
  @Previewable @State var text: String = ""
  PickerTextfield(
    placeholder: "Pick an option",
    options: [
      "Cups",
      "Tbsp",
      "Kgs",
      "Liters"
    ],
    value: $text
  )
  .padding()
}
