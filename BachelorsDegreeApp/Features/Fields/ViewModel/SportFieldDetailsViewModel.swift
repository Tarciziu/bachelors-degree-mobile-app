//
//  SportFieldDetailsViewModel.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 30.05.2022.
//

import Foundation
import CoreLocation

class SportFieldDetailsViewModel: ObservableObject {
  // MARK: - Published Properties
  
  @Published private(set) var presentationState: LoadingState<SportFieldUIModel, SportFieldsPresentationError> = .loading()
  
  // MARK: - Public Properties
  
  let aboutSectionTitle = NSLocalizedString("sportFields.list.item.about.title", comment: "")
  let createReservationButtonText = NSLocalizedString("sportFields.list.item.button.title", comment: "")
  
  // MARK: - Private Properties
  private var service: SportFieldsService
  private var state: SportFieldsState
  private var mapper: SportFieldsUIMapper
  private let geocoder: CLGeocoder
  private let fieldID: Int
  
  // MARK: - Init
  
  init(service: SportFieldsService,
       state: SportFieldsState,
       mapper: SportFieldsUIMapper,
       geocoder: CLGeocoder,
       fieldID: Int) {
    self.service = service
    self.state = state
    self.mapper = mapper
    self.geocoder = geocoder
    self.fieldID = fieldID
    
    attachToState()
  }
  
  // MARK: - Attach to state
  
  private func attachToState() {
    state.$sportsState.receive(on: RunLoop.main)
      .map({ loadingState -> LoadingState<SportFieldUIModel, SportFieldsPresentationError> in
        
        guard let currentFields = loadingState.currentValue else {
          return .failed(.failure(""))
        }
        
        guard let currentField = currentFields.first(where: { $0.identifier == self.fieldID }) else {
          return .failed(.failure(""))
        }
        
        switch loadingState {
        case .loading:
          return .loading(currentValue: self.mapper.convertToUIModel(from: currentField))
          
        case .loaded:
          return .loaded(newValue: self.mapper.convertToUIModel(from: currentField))
          
        case .failed(let error, _):
          let message: String
          switch error {
          case .noInternet:
            message = "No Internet Connection"
          case .internalFailure:
            message = "Internal Failure"
          case .entryNotFound:
            message = "Sport Field Not Found"
          case .serverError(let error):
            message = error
          }
          
          return .failed(.failure(message),
                         currentValue: self.mapper.convertToUIModel(from: currentField))
        }
      })
      .assign(to: &$presentationState)
  }
  
  func getLocationURL(locationString: String, completionHandler: @escaping (String) -> Void) {
    var locationURL: URL? = nil
    geocoder.geocodeAddressString(locationString) { placemarks, error in
      guard error == nil,
            let placemark = placemarks?.first,
            let latitude = placemark.location?.coordinate.latitude,
            let longitude = placemark.location?.coordinate.longitude else {
              return
            }
      
      let url = "maps://?daddr=\(latitude),\(longitude)"
      
      locationURL = URL(string: url)
      
      let currentState = self.presentationState.currentValue
      
      if var currentState = currentState {
        currentState.link = locationURL
        self.presentationState = .loaded(newValue: currentState)
      }
      
      completionHandler(url)
    }
  }
  
  func handleCreateReservationButtonPress() {
    let currentValues = state.sportsState.currentValue
    if var validCurrentValues = currentValues {
      let index = validCurrentValues.firstIndex(where: { $0.identifier == self.fieldID })
      guard let validIndex = index else {
        return
      }
      service.updateField(updatedField: validCurrentValues[validIndex])
    }
  }
}
