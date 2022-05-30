//
//  SportFieldsDTOs.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 30.05.2022.
//

import Foundation

enum SportFieldsDTOs {
  struct FieldResponse: Decodable {
    let id: Int
    let title: String
    let address: String
    let city: String
    let description: String
    let sport: String
    
    enum CodingKeys: String, CodingKey {
      case id
      case title = "name"
      case address
      case city
      case description
      case sport
    }
  }
  
  struct FieldRequest: Encodable {
    let id: Int
    let title: String
    let address: String
    let city: String
    let description: String
    let sport: String
    
    enum CodingKeys: String, CodingKey {
      case id
      case title = "name"
      case address
      case city
      case description
      case sport
    }
  }
}

