//
//  DefaultReservationService.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 28.06.2022.
//

import Foundation
import Combine

class DefaultReservationService: ReservationService {
  
  // MARK: - Private Properties
  
  private var reservationRepository: ReservationRepository
  private var state: ReservationsState
  private var subscriptions: [AnyCancellable] = []
  
  // MARK: - Init
  
  init(reservationState: ReservationsState,
       reservationRepository: ReservationRepository) {
    self.state = reservationState
    self.reservationRepository = reservationRepository
  }
  
  func addReservation(reservation: Reservation, userId: String) {
    self.beginLoading()
    let addPublisher = reservationRepository.add(reservation: reservation, userId: userId)
    addPublisher.sink(receiveCompletion: { completion in
      switch completion {
      case .finished:
        debugPrint("Succes: The reservation was created")
      case .failure(let addError):
        debugPrint("Reservation Operation failed: \(addError)")
        self.endLoading(error: addError)
      }
    }, receiveValue: { reservation in
      var reservations = self.state.reservationsState.currentValue
      reservations?.append(reservation)
      self.endLoading(reservations: reservations)
    }).store(in: &subscriptions)
  }
  
  func updateReservation(updatedReservation: Reservation) {
    beginLoading()
    let updatePublisher = reservationRepository.update(updatedReservation: updatedReservation)
    updatePublisher.sink(receiveCompletion: { completion in
      switch completion {
      case .finished:
        debugPrint("Succes: The reservation was updated")
      case .failure(let updateError):
        debugPrint("Update Operation failed: \(updateError)")
        self.endLoading(error: updateError)
      }
    }, receiveValue: { reservation in
      var reservations = self.state.reservationsState.currentValue
      guard let index = reservations?.firstIndex(of: reservation) else {
        self.endLoading(error: .entryNotFound)
        return
      }
      reservations?[index] = reservation
      self.endLoading(reservations: reservations)
    })
      .store(in: &subscriptions)
  }
  
  func deleteReservation(reservation: Reservation) {
    beginLoading()
    let deletePublisher = reservationRepository.delete(reservation: reservation)
    deletePublisher.sink(receiveCompletion: { completion in
      switch completion {
      case .finished:
        debugPrint("Succes: Reservation deleted successfuly!")
      case .failure(let deleteError):
        debugPrint("Delete Operation failed: \(deleteError)")
        self.endLoading(error: deleteError)
      }
    }, receiveValue: { reservation in
      var reservations = self.state.reservationsState.currentValue
      guard let index = reservations?.firstIndex(of: reservation) else {
        self.endLoading(error: .entryNotFound)
        return
      }
      reservations?.remove(at: index)
      self.endLoading(reservations: reservations)
    })
      .store(in: &subscriptions)
  }
  
  func fetchAllReservations(userId: String) {
    beginLoading()
    let fieldsPublisher = reservationRepository.getAllReservations(userId: userId)
    fieldsPublisher.sink(receiveCompletion: { completion in
      switch completion {
      case .finished:
        debugPrint("Succes: Reservations fetched successfuly!")
      case .failure(let fieldsError):
        debugPrint("Fetch Operation failed: \(fieldsError)")
        self.endLoading(error: fieldsError)
      }
    }, receiveValue: handleFetchAllValue)
      .store(in: &subscriptions)
  }
  
  private func handleFetchAllValue(value: [Reservation]) {
    self.endLoading(reservations: value)
  }
  
  private func beginLoading() {
    state.reservationsState = .loading(currentValue: state.reservationsState.currentValue)
  }
  
  private func endLoading(reservations: [Reservation]?) {
    state.reservationsState = .loaded(newValue: reservations)
  }
  
  private func endLoading(error: RepositoryError) {
    state.reservationsState = .failed(error, currentValue: state.reservationsState.currentValue)
  }
}
