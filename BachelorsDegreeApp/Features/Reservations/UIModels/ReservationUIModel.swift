//
//  ReservationUIModel.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 28.06.2022.
//

import Foundation

struct ReservationUIModel: Hashable {
  let id: Int
  var sportField: SportFieldUIModel
  let date: String
  let hour: String
}
