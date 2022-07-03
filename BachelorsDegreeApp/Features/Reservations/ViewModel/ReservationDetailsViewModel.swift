//
//  ReservationDetailsViewModel.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 29.06.2022.
//

import Foundation
import CoreLocation

class ReservationDetailsViewModel: ObservableObject {
  // MARK: - Published Properties
  
  @Published private(set) var presentationState: LoadingState<ReservationUIModel, ReservationsPresentationError> = .loading()
  
  // MARK: - Public Properties
  
  let aboutSectionTitle = NSLocalizedString("sportFields.list.item.about.title", comment: "")
  let createReservationButtonText = NSLocalizedString("sportFields.list.item.button.title", comment: "")
  
  // MARK: - Private Properties
  private var service: ReservationService
  private var state: ReservationsState
  private var mapper: ReservationUIMapper
  private let geocoder: CLGeocoder
  private let reservationID: Int
  
  // MARK: - Init
  
  init(service: ReservationService,
       state: ReservationsState,
       mapper: ReservationUIMapper,
       geocoder: CLGeocoder,
       reservationID: Int) {
    self.service = service
    self.state = state
    self.mapper = mapper
    self.geocoder = geocoder
    self.reservationID = reservationID
    
    attachToState()
  }
  
  // MARK: - Attach to state
  
  private func attachToState() {
    state.$reservationsState.receive(on: RunLoop.main)
      .map({ loadingState -> LoadingState<ReservationUIModel, ReservationsPresentationError> in
        
        guard let currentReservations = loadingState.currentValue else {
          return .failed(.failure(""))
        }
        
        guard let currentReservation = currentReservations.first(where: { $0.identifier == self.reservationID }) else {
          return .failed(.failure(""))
        }
        
        switch loadingState {
        case .loading:
          return .loading(currentValue: self.mapper.convertToUIModel(from: currentReservation))
          
        case .loaded:
          return .loaded(newValue: self.mapper.convertToUIModel(from: currentReservation))
          
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
                         currentValue: self.mapper.convertToUIModel(from: currentReservation))
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
        currentState.sportField.link = locationURL
        self.presentationState = .loaded(newValue: currentState)
      }
      
      completionHandler(url)
    }
  }
}
