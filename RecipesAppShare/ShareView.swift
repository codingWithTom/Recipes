//
//  ShareView.swift
//  RecipesAppShare
//
//  Created by Tomas Trujillo on 2026-05-11.
//

import SwiftUI

struct ShareView: View {
  let onClose: () -> Void
  @State private var viewModel: ShareViewModel

  init(url: URL, onClose: @escaping () -> Void) {
    self.onClose = onClose
    _viewModel = State(wrappedValue: ShareViewModel(url: url))
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      HStack {
        Button { onClose() } label: {
          Image(systemName: "xmark")
            .padding()
        }
        Spacer()
        if case .loaded = viewModel.state {
          Button {
            Task { await viewModel.confirm(); onClose() }
          } label: {
            Image(systemName: "checkmark")
              .padding()
          }
        }
      }
      .padding(20)
      stateContent
    }
    .task { await viewModel.load() }
  }

  @ViewBuilder
  private var stateContent: some View {
    switch viewModel.state {
    case .loading:
      ProgressView()
    case .error:
      Text("Failed to load recipe")
    case .loaded(let content):
      ScrollView {
        VStack(alignment: .leading, spacing: 12) {
          if let data = content.imageData, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
              .resizable()
              .scaledToFit()
              .frame(maxHeight: 200)
          }
          Text(content.title)
            .font(.headline)
          Text(content.description)
            .font(.body)
          HStack {
            Text("\(content.cookingTime) min")
            Spacer()
            Text("\(content.servings) servings")
          }
          .font(.subheadline)
        }
        .padding()
      }
    }
  }
}
