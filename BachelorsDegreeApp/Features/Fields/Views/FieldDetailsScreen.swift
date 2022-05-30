//
//  FieldDetailsScreen.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 30.05.2022.
//

import SwiftUI
import CoreLocation

struct FieldDetailsScreen: View {
  @StateObject var viewModel: SportFieldDetailsViewModel
  @Environment(\.openURL) var openURL
  @State var showCreateReservation = false
  
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
      .sheet(isPresented: $showCreateReservation) {
        NavigationView {
          CreateReservationView()
            .toolbar {
              Button {
                self.showCreateReservation.toggle()
              } label: {
                Image("Close")
              }
              .foregroundColor(ColorsCatalog.primaryText)
            }
        }
      }
  }
  
  private func detailsView(with model: SportFieldUIModel?) -> some View {
    let defaultSportFieldImage = "Login"
    return ZStack {
      if let model = model {
        ScrollView {
          VStack(alignment: .leading, spacing: 28.0) {
            switch model.image {
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
              
              aboutSection(description: model.description)
              
              Spacer()
            }
            .padding(24.0)
          }
        }
        
        floatingButton(with: model)
        
      } else {
        EmptyView()
      }
    }
  }
  
  private func informations(with model: SportFieldUIModel) -> some View {
    return VStack(alignment: .leading, spacing: 16.0) {
      Text(model.title)
        .foregroundColor(ColorsCatalog.accent)
        .font(FontsCatalog.heading1)
      
      locationSection(with: model)
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
  
  private func floatingButton(with model: SportFieldUIModel) -> some View {
    return FloatingButton(text: viewModel.createReservationButtonText,
                          action: {
      
      self.showCreateReservation.toggle()
    },
                          maxHeight: 50.0,
                          foregroundColor: .white,
                          font: FontsCatalog.confirmationButton,
                          clipShape: RoundedRectangle(cornerRadius: 12.0),
                          backgroundColor: ColorsCatalog.primaryText)
      .padding(.horizontal, 26.0)
      .padding(.bottom, 12.0)
  }
}

private extension Image {
  
  func sportFieldResizeImage() -> some View {
    self
      .resizable()
      .scaledToFit()
  }
}

struct FieldDetailsScreen_Previews: PreviewProvider {
  static var previews: some View {
    let repository = MockedSportFieldsRepository(timeInterval: 3.0,
                                                 failAllOperations: false)
    let state = SportFieldsState()
    let service = DefaultSportFieldsService(sportFieldsState: state,
                                            fieldsRepository: repository)
    let mapper = DefaultSportFieldsUIMapper()
    let geocoder = CLGeocoder()
    let viewModel = SportFieldDetailsViewModel(service: service,
                                               state: state,
                                               mapper: mapper,
                                               geocoder: geocoder,
                                               fieldID: 1)
    FieldDetailsScreen(viewModel: viewModel)
  }
}
