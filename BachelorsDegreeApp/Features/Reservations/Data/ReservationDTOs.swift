//
//  ReservationDTOs.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 28.06.2022.
//

import Foundation

enum ReservationDTOs {
  struct ReservationResponse: Decodable {
    let id: Int
    let sportField: SportFieldsDTOs.FieldResponse
    let day: String
    let hour: Int
    
    enum CodingKeys: String, CodingKey {
      case id
      case sportField = "sportFieldId"
      case day
      case hour
    }
  }
  
  struct ReservationRequest: Encodable {
    let userID: String
    let sportFieldId: Int
    let day: String
    let hour: Int
    
    enum CodingKeys: String, CodingKey {
      case userID
      case sportFieldId
      case day = "date"
      case hour
    }
  }
}
