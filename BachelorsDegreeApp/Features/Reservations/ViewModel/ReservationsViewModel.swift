//
//  ReservationsViewModel.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 28.06.2022.
//

import Foundation
import Combine

enum ReservationsPresentationError: LocalizedError {
  case failure(String)
  
  var errorDescription: String? {
    return "Error"
  }
  
  var failureReason: String? {
    switch self {
    case .failure(let reason):
      return reason
    }
  }
}

// MARK: - Main Type
class ReservationsViewModel: ObservableObject {
  
  // MARK: - Published Properties
  
  @Published private(set) var presentationState: LoadingState<[ReservationUIModel], ReservationsPresentationError> = .loading()
  
  // MARK: - Public Properties
  
  let listTitle = NSLocalizedString("myReservations.list.title", comment: "")
  
  private var cancellables = Set<AnyCancellable>()
  
  // MARK: - Dependencies
  
  private var service: ReservationService
  private var state: ReservationsState
  private var mapper: ReservationUIMapper
  
  // MARK: - Private Properties
  
  private var loggedUserId: String
  
  // MARK: - Init
  
  init(service: ReservationService,
       state: ReservationsState,
       mapper: ReservationUIMapper,
       loggedUserId: String) {
    self.service = service
    self.state = state
    self.mapper = mapper
    self.loggedUserId = loggedUserId
    
    // Setup
    self.attachToState()
    
    fetchFields()
  }
  
  // MARK: - Attach to state
  
  private func attachToState() {
    state.$reservationsState.receive(on: RunLoop.main)
      .map({ loadingState -> LoadingState<[ReservationUIModel], ReservationsPresentationError> in
        switch loadingState {
        case .loading(currentValue: let currentReservations):
          return .loading(currentValue: self.mapper.convertToUIModel(from: currentReservations ?? []))
          
        case .loaded(let newReservations):
          return .loaded(newValue: self.mapper.convertToUIModel(from: newReservations ?? []))
          
        case .failed(let error, let currentReservations):
          let message: String
          switch error {
          case .noInternet:
            message = NSLocalizedString("error.noInternet", comment: "")
          case .internalFailure:
            message = NSLocalizedString("supportGroups.list.error.loading", comment: "")
          case .entryNotFound:
            message = NSLocalizedString("supportGroups.item.error.notFound", comment: "")
          case .serverError(message: let msg):
            message = msg
          }
          return .failed(.failure(message),
                         currentValue: self.mapper.convertToUIModel(from: currentReservations ?? []))
        }
      })
      .assign(to: &$presentationState)
  }
  
  // MARK: - Sport Fields View-Model
  
  func fetchFields() {
    service.fetchAllReservations(userId: loggedUserId)
  }
}

