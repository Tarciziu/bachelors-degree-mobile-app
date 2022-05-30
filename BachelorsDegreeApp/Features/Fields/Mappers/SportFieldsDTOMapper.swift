//
//  SportFieldsDTOMapper.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 30.05.2022.
//

import Foundation

protocol SportFieldsDTOMapper {
  func convertToSportField(from fieldDTO: SportFieldsDTOs.FieldResponse) -> SportField
  func convertToSportFieldsArray(from fieldDTOs: [SportFieldsDTOs.FieldResponse]) -> [SportField]
  func convertToDTO(from field: SportField) -> SportFieldsDTOs.FieldRequest
}

