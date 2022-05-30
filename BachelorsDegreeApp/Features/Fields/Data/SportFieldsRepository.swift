//
//  SportFieldsRepository.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 29.05.2022.
//

import Foundation
import Combine

protocol SportFieldsRepository {
  func add(field: SportField) -> AnyPublisher<SportField, RepositoryError>
  func update(updatedField: SportField) -> AnyPublisher<SportField, RepositoryError>
  func delete(field: SportField) -> AnyPublisher<SportField, RepositoryError>
  func getAllFieldsPublisher() -> AnyPublisher<[SportField], RepositoryError>
}
