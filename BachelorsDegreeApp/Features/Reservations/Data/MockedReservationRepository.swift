//
//  MockedReservationRepository.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 28.06.2022.
//

import Foundation
import Combine

class MockedReservationRepository: ReservationRepository {
  
  // MARK: - Private Properties
  
  private var reservations: [Reservation] = []
  private var timeInterval: TimeInterval
  private var failAllOperations: Bool
  
  init(timeInterval: TimeInterval,
       failAllOperations: Bool = false) {
    self.timeInterval = timeInterval
    self.failAllOperations = failAllOperations
    let sportField = SportField(identifier: 0,
                               title: "CBC Teren fotbal",
                               description: "Teren sintetic minifotbal",
                               address: "Str. Bucuresti 6",
                               city: "Cluj-Napoca",
                               sport: .football)
    self.add(reservation: Reservation(identifier: 0,
                                      sportField: sportField,
                                      day: Date.now,
                                      hour: 18),
             userId: "mail@mail.com")
    self.add(reservation: Reservation(identifier: 1,
                                      sportField: sportField,
                                      day: Date.now,
                                      hour: 20),
             userId: "mail@mail.com")
  }
  
  func add(reservation: Reservation, userId: String) -> AnyPublisher<Reservation, RepositoryError> {
    return Future<Reservation, RepositoryError> { promise in
      DispatchQueue.main.asyncAfter(deadline: .now() + self.timeInterval, execute: {
        self.reservations.append(reservation)
        promise(.success(reservation))
      })
    }
    .eraseToAnyPublisher()
  }
  
  func update(updatedReservation: Reservation) -> AnyPublisher<Reservation, RepositoryError> {
    return Future<Reservation, RepositoryError> { promise in
      DispatchQueue.main.asyncAfter(deadline: .now() + self.timeInterval, execute: {
        guard !self.failAllOperations else {
          promise(.failure(.internalFailure))
          return
        }
        
        guard let index = self.reservations.firstIndex(where: {reservation in
          return reservation == updatedReservation
        }) else {
          promise(.failure(.entryNotFound))
          return
        }
        
        self.reservations[index] = updatedReservation
        promise(.success(updatedReservation))
      })
    }
    .eraseToAnyPublisher()
  }
  
  func delete(reservation: Reservation) -> AnyPublisher<Reservation, RepositoryError> {
    return Future<Reservation, RepositoryError> { promise in
      DispatchQueue.main.asyncAfter(deadline: .now() + self.timeInterval, execute: {
        guard !self.failAllOperations else {
          promise(.failure(.internalFailure))
          return
        }
        
        guard let index = self.reservations.firstIndex(where: { (existingItem) -> Bool in
          return existingItem == reservation
        }) else {
          promise(.failure(.entryNotFound))
          return
        }
        
        self.reservations.remove(at: index)
        promise(.success(reservation))
      })
    }
    .eraseToAnyPublisher()
  }
  
  func getAllReservations(userId: String) -> AnyPublisher<[Reservation], RepositoryError> {
    return Future<[Reservation], RepositoryError> { promise in
      DispatchQueue.global(qos: .background).async {
        
        promise(.success(self.reservations))
      }
    }
    .eraseToAnyPublisher()
  }
  
  
}
