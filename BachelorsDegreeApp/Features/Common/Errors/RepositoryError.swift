//
//  RepositoryError.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 29.05.2022.
//

import Foundation

enum RepositoryError: Error {
  case internalFailure
  case noInternet
  case entryNotFound
  case serverError(String)
}
