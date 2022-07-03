//
//  ReservationDTOMapper.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 28.06.2022.
//

import Foundation

protocol ReservationDTOMapper {
  func convertToReservation(from reservationDTO: ReservationDTOs.ReservationResponse) -> Reservation
  func convertToReservationsArray(from reservationDTOs: [ReservationDTOs.ReservationResponse]) -> [Reservation]
  func convertToDTO(from reservation: Reservation, userId: String) -> ReservationDTOs.ReservationRequest
}
