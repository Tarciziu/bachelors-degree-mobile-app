//
//  ReservationService.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 30.05.2022.
//

import Foundation

protocol ReservationService {
  func addReservation(reservation: Reservation)
  func updateReservation(updatedReservation: Reservation)
  func deleteReservation(reservation: Reservation)
  func fetchAllReservations()
}
