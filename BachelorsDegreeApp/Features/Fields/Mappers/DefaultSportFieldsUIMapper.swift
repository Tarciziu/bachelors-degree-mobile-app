//
//  DefaultSportFieldsUIMapper.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 29.05.2022.
//

import Foundation

class DefaultSportFieldsUIMapper: SportFieldsUIMapper {
  func convertToUIModel(from field: SportField) -> SportFieldUIModel {
    let uiModel = SportFieldUIModel(id: field.identifier,
                                    title: field.title,
                                    description: field.description,
                                    image: .placeholder,
                                    address: field.address,
                                    city: field.city)
    return uiModel
  }
  
  func convertToUIModel(from fields: [SportField]) -> [SportFieldUIModel] {
    return fields.map(convertToUIModel)
  }
  
  
}
