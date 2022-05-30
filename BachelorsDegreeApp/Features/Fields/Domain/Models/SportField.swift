//
//  SportField.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 29.05.2022.
//

import Foundation

struct SportField: Equatable {
  enum Sport {
    case football
    case handball
    case voley
    case basketball
    case tabletennis
    case tennis
  }
  
  let identifier: Int
  let title: String
  let description: String
  let address: String
  let city: String
  let sport: Sport
  
  static func == (lhs: SportField, rhs: SportField) -> Bool {
    return lhs.identifier == rhs.identifier
  }
}
