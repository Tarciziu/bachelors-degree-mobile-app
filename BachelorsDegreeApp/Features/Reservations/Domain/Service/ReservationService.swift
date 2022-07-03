//
//  ReservationService.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 30.05.2022.
//

import Foundation

protocol ReservationService {
  func addReservation(reservation: Reservation, userId: String)
  func updateReservation(updatedReservation: Reservation)
  func deleteReservation(reservation: Reservation)
  func fetchAllReservations(userId: String)
}
