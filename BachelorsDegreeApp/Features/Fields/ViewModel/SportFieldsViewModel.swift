//
//  SportFieldsViewModel.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 29.05.2022.
//

import Foundation
import Combine

enum SportFieldsPresentationError: LocalizedError {
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
class SportFieldsViewModel: ObservableObject {
  
  // MARK: - Published Properties
  
  @Published private(set) var presentationState: LoadingState<[SportFieldUIModel], SportFieldsPresentationError> = .loading()
  
  // MARK: - Public Properties
  
  let listTitle = NSLocalizedString("sportFields.list.title", comment: "")
  let searchbarHintText = NSLocalizedString("sportFields.list.search.hintText", comment: "")
//
//  let aboutSectionTitle = NSLocalizedString("supportGroups.list.item.about.title", comment: "")
//  let occurrence = NSLocalizedString("supportGroups.list.item.details.occurrence", comment: "")
//  let participantsTitle = NSLocalizedString("supportGroups.list.item.participants.title", comment: "")
//  let emptyListText = NSLocalizedString("supportGroups.list.emptyList.message", comment: "")
  
  private var cancellables = Set<AnyCancellable>()
  
  // MARK: - Dependencies
  
  private var service: SportFieldsService
  private var state: SportFieldsState
  private var mapper: SportFieldsUIMapper
  
  // MARK: - Init
  
  init(service: SportFieldsService,
       state: SportFieldsState,
       mapper: SportFieldsUIMapper) {
    self.service = service
    self.state = state
    self.mapper = mapper
    
    // Setup
    self.attachToState()
    
    fetchFields()
  }
  
  // MARK: - Attach to state
  
  private func attachToState() {
    state.$sportsState.receive(on: RunLoop.main)
      .map({ loadingState -> LoadingState<[SportFieldUIModel], SportFieldsPresentationError> in
        switch loadingState {
        case .loading(currentValue: let currentFields):
          return .loading(currentValue: self.mapper.convertToUIModel(from: currentFields ?? []))
          
        case .loaded(let newFields):
          return .loaded(newValue: self.mapper.convertToUIModel(from: newFields ?? []))
          
        case .failed(let error, let currentFields):
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
                         currentValue: self.mapper.convertToUIModel(from: currentFields ?? []))
        }
      })
      .assign(to: &$presentationState)
  }
  
  // MARK: - Sport Fields View-Model
  
  private func fetchFields() {
    service.fetchAllSportFields()
  }
}
