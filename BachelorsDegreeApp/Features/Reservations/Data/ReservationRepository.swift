//
//  ReservationRepository.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 28.06.2022.
//

import Foundation
import Combine

protocol ReservationRepository {
  func add(reservation: Reservation, userId: String) -> AnyPublisher<Reservation, RepositoryError>
  func update(updatedReservation: Reservation) -> AnyPublisher<Reservation, RepositoryError>
  func delete(reservation: Reservation) -> AnyPublisher<Reservation, RepositoryError>
  func getAllReservations(userId: String) -> AnyPublisher<[Reservation], RepositoryError>
}
