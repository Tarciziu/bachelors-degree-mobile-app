//
//  DefaultSportFieldsDTOMapper.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 30.05.2022.
//

import Foundation

class DefaultSportFieldsDTOMapper: SportFieldsDTOMapper {
  func convertToSportField(from fieldDTO: SportFieldsDTOs.FieldResponse) -> SportField {
    let identifier = fieldDTO.id
    let title = fieldDTO.title
    let description = fieldDTO.description
    let address = fieldDTO.address
    let city = fieldDTO.city
    let sport: SportField.Sport
    switch fieldDTO.sport {
    case "FOOTBALL":
      sport = .football
    case "BASKETBALL":
      sport = .basketball
    case "TENNIS":
      sport = .tennis
    case "TABLE_TENNIS":
      sport = .tabletennis
    case "VOLEY":
      sport = .voley
    default:
      sport = .football
    }
    
    let sportField = SportField(identifier: identifier,
                                title: title,
                                description: description,
                                address: address,
                                city: city,
                                sport: sport)
    return sportField
  }
  
  func convertToSportFieldsArray(from fieldDTOs: [SportFieldsDTOs.FieldResponse]) -> [SportField] {
    fieldDTOs.map { convertToSportField(from: $0) }
  }
  
  func convertToDTO(from field: SportField) -> SportFieldsDTOs.FieldRequest {
    let identifier = field.identifier
    let title = field.title
    let description = field.description
    let address = field.address
    let city = field.city
    let sport: String
    switch field.sport {
    case .football:
      sport = "FOOTBALL"
    case .basketball:
      sport = "BASKETBALL"
    case .tennis:
      sport = "TENNIS"
    case .tabletennis:
      sport = "TABLE_TENNIS"
    case .voley:
      sport = "VOLEY"
    default:
      sport = "FOOTBALL"
    }
    
    let sportFieldDTO = SportFieldsDTOs.FieldRequest(id: identifier,
                                                     title: title,
                                                     address: address,
                                                     city: city,
                                                     description: description,
                                                     sport: sport)
    return sportFieldDTO
  }
  
  
}
