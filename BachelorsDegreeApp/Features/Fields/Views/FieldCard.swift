//
//  FieldCard.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 07.05.2022.
//

import SwiftUI

struct FieldCard: View {
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0.0) {
      HStack(alignment: .center, spacing: 16.0) {
        Image("Login")
          .fieldResizeImage()
        VStack(alignment: .leading, spacing: 8.0) {
          Text("Title")
            .font(FontsCatalog.listItemTitle)
            .foregroundColor(ColorsCatalog.primaryText)
          Text("Address, City")
            .font(FontsCatalog.paragraph)
            .foregroundColor(ColorsCatalog.secondaryText)
        }
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
    FieldCard()
  }
}
