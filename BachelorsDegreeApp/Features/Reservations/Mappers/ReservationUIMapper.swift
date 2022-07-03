//
//  ReservationUIMapper.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 28.06.2022.
//

import Foundation

protocol ReservationUIMapper {
  func convertToUIModel(from reservation: Reservation) -> ReservationUIModel
  func convertToUIModel(from reservations: [Reservation]) -> [ReservationUIModel]
}
