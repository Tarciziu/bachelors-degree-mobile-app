//
//  FieldCard.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 07.05.2022.
//

import SwiftUI

struct FieldCard: View {
  
  private let model: SportFieldUIModel
  
  init(model: SportFieldUIModel) {
    self.model = model
  }
  
  var body: some View {
    let defaultSportFieldImage = "Login"
    VStack(alignment: .leading, spacing: 0.0) {
      HStack(alignment: .center, spacing: 16.0) {
        switch model.image {
        case .url(let source):
          AsyncImage(url: source) { img in
            img
              .fieldResizeImage()
          } placeholder: {
            ProgressView()
              .progressViewStyle(.circular)
              .frame(width: 88.0, height: 88.0)
          }
        case .asset(let name):
          Image(name)
            .fieldResizeImage()
        case .system(let name):
          Image(systemName: name)
            .fieldResizeImage()
        case .placeholder:
          Image(defaultSportFieldImage)
            .fieldResizeImage()
        }
        VStack(alignment: .leading, spacing: 8.0) {
          title
          location(address: model.address, city: model.city)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
      }
      .padding(EdgeInsets(top: 24.0, leading: 16.0, bottom: 24.0, trailing: 16.0))
    }
    .background(ColorsCatalog.listItemBackground)
    .shadow(color: ColorsCatalog.listItemShadow, radius: 8.0, x: 0.0, y: 4.0)
    .cornerRadius(8.0)
    .overlay(
      RoundedRectangle(cornerRadius: 8.0, style: .continuous)
        .stroke(ColorsCatalog.listItemBorder, lineWidth: 1.0))
  }
  
  @ViewBuilder private var title: some View {
    Text(model.title)
      .font(FontsCatalog.listItemTitle)
      .foregroundColor(ColorsCatalog.primaryText)
  }
  
  private func location(address: String, city: String) -> some View {
    let location = address + " " + city
    return Text(location)
      .font(FontsCatalog.paragraph)
      .foregroundColor(ColorsCatalog.secondaryText)
  }
}

private extension Image {
  
  func fieldResizeImage() -> some View {
    self
      .resizable()
      .scaledToFill()
      .frame(width: 88.0, height: 88.0)
      .cornerRadius(8.0)
  }
}

struct FieldCard_Previews: PreviewProvider {
  static var previews: some View {
    let model = SportFieldUIModel(id: 0,
                                  title: "CBC Teren fotbal",
                                  description: "Teren minifotbal sintetic",
                                  image: .placeholder,
                                  address: "Bucuresti 6",
                                  city: "Cluj-Napoca")
    FieldCard(model: model)
  }
}
