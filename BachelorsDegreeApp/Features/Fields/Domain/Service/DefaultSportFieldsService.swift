//
//  DefaultSportFieldsService.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 29.05.2022.
//

import Foundation
import Combine

class DefaultSportFieldsService: SportFieldsService {
  
  // MARK: - Private Properties
  
  private var fieldsRepository: SportFieldsRepository
  private var state: SportFieldsState
  private var subscriptions: [AnyCancellable] = []
  
  // MARK: - Init
  
  init(sportFieldsState: SportFieldsState,
       fieldsRepository: SportFieldsRepository) {
    self.state = sportFieldsState
    self.fieldsRepository = fieldsRepository
  }
  
  func addField(field: SportField) {
    beginLoading()
    let addPublisher = fieldsRepository.add(field: field)
    addPublisher.sink(receiveCompletion: { completion in
      switch completion {
      case .finished:
        debugPrint("Succes: The event was added")
      case .failure(let addError):
        debugPrint("Addition Operation failed: \(addError)")
        self.endLoading(error: addError)
      }
    }, receiveValue: { event in
      var fields = self.state.sportsState.currentValue
      fields?.append(field)
      self.endLoading(fields: fields)
    }).store(in: &subscriptions)
  }
  
  func updateField(updatedField: SportField) {
    beginLoading()
    let updatePublisher = fieldsRepository.update(updatedField: updatedField)
    updatePublisher.sink(receiveCompletion: { completion in
      switch completion {
      case .finished:
        debugPrint("Succes: The event was updated")
      case .failure(let updateError):
        debugPrint("Update Operation failed: \(updateError)")
        self.endLoading(error: updateError)
      }
    }, receiveValue: { field in
      var fields = self.state.sportsState.currentValue
      guard let index = fields?.firstIndex(of: field) else {
        self.endLoading(error: .entryNotFound)
        return
      }
      fields?[index] = field
      self.endLoading(fields: fields)
    })
      .store(in: &subscriptions)
  }
  
  func deleteField(field: SportField) {
    beginLoading()
    let deletePublisher = fieldsRepository.delete(field: field)
    deletePublisher.sink(receiveCompletion: { completion in
      switch completion {
      case .finished:
        debugPrint("Succes: Event deleted successfuly!")
      case .failure(let deleteError):
        debugPrint("Delete Operation failed: \(deleteError)")
        self.endLoading(error: deleteError)
      }
    }, receiveValue: { field in
      var fields = self.state.sportsState.currentValue
      guard let index = fields?.firstIndex(of: field) else {
        self.endLoading(error: .entryNotFound)
        return
      }
      fields?.remove(at: index)
      self.endLoading(fields: fields)
    })
      .store(in: &subscriptions)
  }
  
  func fetchAllSportFields() {
    beginLoading()
    let fieldsPublisher = fieldsRepository.getAllFieldsPublisher()
    fieldsPublisher.sink(receiveCompletion: { completion in
      switch completion {
      case .finished:
        debugPrint("Succes: Event fetched successfuly!")
      case .failure(let fieldsError):
        debugPrint("Fetch Operation failed: \(fieldsError)")
        self.endLoading(error: fieldsError)
      }
    }, receiveValue: handleFetchAllValue)
      .store(in: &subscriptions)
  }
  
  private func handleFetchAllValue(value: [SportField]) {
    self.endLoading(fields: value)
  }
  
  private func beginLoading() {
    state.sportsState = .loading(currentValue: state.sportsState.currentValue)
  }
  
  private func endLoading(fields: [SportField]?) {
    state.sportsState = .loaded(newValue: fields)
  }
  
  private func endLoading(error: RepositoryError) {
    state.sportsState = .failed(error, currentValue: state.sportsState.currentValue)
  }
  
}
