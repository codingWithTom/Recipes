import SwiftUI

struct RecipeImage: View {
  let recipe: Recipe
  let fontSize: CGFloat
  let cornerRadius: CGFloat

  var body: some View {
    Group {
      if let data = recipe.imageData, let uiImage = UIImage(data: data) {
        Image(uiImage: uiImage)
          .resizable()
          .scaledToFit()
          .clipped()
      } else {
        Image(systemName: recipe.imageName)
          .font(.system(size: fontSize))
          .foregroundStyle(.secondary)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
  }
}
