//
//  Reservation.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 30.05.2022.
//

import Foundation

struct Reservation: Equatable {
  let identifier: Int
  let sportField: SportField
  let day: Date
  let hour: Int
  
  static func == (lhs: Reservation, rhs: Reservation) -> Bool {
    return lhs.identifier == rhs.identifier
  }
}
