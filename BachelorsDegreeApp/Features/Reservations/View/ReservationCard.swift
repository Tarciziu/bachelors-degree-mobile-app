//
//  ReservationCard.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 28.06.2022.
//

import SwiftUI

struct ReservationCard: View {
  
  private let model: ReservationUIModel
  
  init(model: ReservationUIModel) {
    self.model = model
  }
  
  var body: some View {
    let defaultSportFieldImage = "Login"
    VStack(alignment: .leading, spacing: 0.0) {
      HStack(alignment: .center, spacing: 16.0) {
        switch model.sportField.image {
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
          location(address: model.sportField.address, city: model.sportField.city)
          dateTime
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
    Text(model.sportField.title)
      .font(FontsCatalog.listItemTitle)
      .foregroundColor(ColorsCatalog.primaryText)
  }
  
  private func location(address: String, city: String) -> some View {
    let location = address + " " + city
    return Text(location)
      .font(FontsCatalog.paragraph)
      .foregroundColor(ColorsCatalog.secondaryText)
  }
  
  @ViewBuilder private var dateTime: some View {
    Text("\(model.date) \(model.hour)")
      .font(FontsCatalog.listItemTitle)
      .foregroundColor(ColorsCatalog.primaryText)
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

struct ReservationCard_Previews: PreviewProvider {
  static var previews: some View {
    let spModel = SportFieldUIModel(id: 0,
                                  title: "CBC Teren fotbal",
                                  description: "Teren minifotbal sintetic",
                                  image: .placeholder,
                                  address: "Bucuresti 6",
                                  city: "Cluj-Napoca")
    
    let model = ReservationUIModel(id: 0,
                                   sportField: spModel,
                                   date: "2022-07-01",
                                   hour: "18:00")
    ReservationCard(model: model)
  }
}
