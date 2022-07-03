//
//  ReservationDetailsScreen.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 29.06.2022.
//

import SwiftUI
import CoreLocation

struct ReservationDetailsScreen: View {
  @StateObject var viewModel: ReservationDetailsViewModel
  @Environment(\.openURL) var openURL
  
  var body: some View {
    detailsView(with: viewModel.presentationState.currentValue)
      .overlay {
        if viewModel.presentationState.isLoading {
          ProgressIndicator()
        }
      }
      .navigationBarTitleDisplayMode(.inline)
      .alert(isPresented: .constant(viewModel.presentationState.isFailed),
             error: viewModel.presentationState.failureReason,
             actions: { _ in
        Button("OK", role: .cancel) { }
      },
             message: { error in
        Text(error.failureReason ?? String())
        
      })
  }
  
  private func detailsView(with model: ReservationUIModel?) -> some View {
    let defaultSportFieldImage = "Login"
    return VStack {
      if let model = model {
        ScrollView {
          VStack(alignment: .leading, spacing: 28.0) {
            switch model.sportField.image {
            case .url(let source):
              AsyncImage(url: source) { img in
                img
                  .sportFieldResizeImage()
              } placeholder: {
                ProgressView()
                  .progressViewStyle(.circular)
                  .frame(width: 88.0, height: 88.0)
              }
            case .asset(let name):
              Image(name)
                .sportFieldResizeImage()
            case .system(let name):
              Image(systemName: name)
                .sportFieldResizeImage()
            case .placeholder:
              Image(defaultSportFieldImage)
                .sportFieldResizeImage()
            }
            
            VStack(alignment: .leading, spacing: 32.0) {
              
              informations(with: model)
              
              aboutSection(description: model.sportField.description)
              
              Spacer()
            }
            .padding(24.0)
          }
        }
      } else {
        EmptyView()
      }
    }
  }
  
  private func dateTime(with model: ReservationUIModel) -> some View {
    return VStack(alignment: .leading, spacing: 0.0) {
      Text(model.date)
        .font(FontsCatalog.listItemLocation)
        .foregroundColor(ColorsCatalog.secondaryText)
      Text(model.hour)
        .font(FontsCatalog.listItemLocation)
        .foregroundColor(ColorsCatalog.secondaryText)
    }
  }
  
  private func informations(with model: ReservationUIModel) -> some View {
    return VStack(alignment: .leading, spacing: 16.0) {
      Text(model.sportField.title)
        .foregroundColor(ColorsCatalog.accent)
        .font(FontsCatalog.heading1)
      
      locationSection(with: model.sportField)
      
      dateTime(with: model)
    }
  }
  
  private func locationSection(with model: SportFieldUIModel) -> some View {
    let locationImageString = "Location"
    
    let address = "\(model.address), \(model.city)"
    
    return Button {
      viewModel.getLocationURL(locationString: address, completionHandler: { urlString in
        if let url = URL(string: urlString) {
          openURL(url)
        }
      })
    } label: {
      Label {
        Text(model.address)
          .font(FontsCatalog.listItemLocation)
          .foregroundColor(ColorsCatalog.secondaryText)
      } icon: {
        Image(locationImageString)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(height: 14.0)
          .foregroundColor(ColorsCatalog.secondaryText)
      }
    }
  }
  
  private func aboutSection(description: String) -> some View {
    return VStack(alignment: .leading, spacing: 4.0) {
      Text(viewModel.aboutSectionTitle)
        .font(FontsCatalog.heading3)
        .foregroundColor(ColorsCatalog.primaryText)
      Text(description)
        .font(FontsCatalog.paragraph)
        .foregroundColor(ColorsCatalog.secondaryText)
    }
  }
}

private extension Image {
  
  func sportFieldResizeImage() -> some View {
    self
      .resizable()
      .scaledToFit()
  }
}

struct ReservationDetailsScreen_Previews: PreviewProvider {
  static var previews: some View {
    let repository = MockedReservationRepository(timeInterval: 3.0,
                                                 failAllOperations: false)
    let state = ReservationsState()
    let service = DefaultReservationService(reservationState: state,
                                            reservationRepository: repository)
    let mapper = DefaultReservationUIMapper()
    let geocoder = CLGeocoder()
    let viewModel = ReservationDetailsViewModel(service: service,
                                                state: state,
                                                mapper: mapper,
                                                geocoder: geocoder,
                                                reservationID: 1)
    ReservationDetailsScreen(viewModel: viewModel)
  }
}
