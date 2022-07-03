//
//  SportFieldsService.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 29.05.2022.
//

import Foundation

protocol SportFieldsService {
  func addField(field: SportField)
  func updateField(updatedField: SportField)
  func deleteField(field: SportField)
  func getValidHours(fieldID: Int, date: Date)
  func fetchAllSportFields()
}
