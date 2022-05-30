//
//  SportFieldsUIMapper.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 29.05.2022.
//

import Foundation

protocol SportFieldsUIMapper {
  func convertToUIModel(from field: SportField) -> SportFieldUIModel
  func convertToUIModel(from fields: [SportField]) -> [SportFieldUIModel]
}
