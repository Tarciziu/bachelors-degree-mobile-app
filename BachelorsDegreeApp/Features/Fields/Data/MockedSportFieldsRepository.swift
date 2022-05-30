//
//  MockedSportFieldsRepository.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 29.05.2022.
//

import Foundation
import Combine

class MockedSportFieldsRepository: SportFieldsRepository {
  
  // MARK: - Private Properties
  
  private var fields: [SportField] = []
  private var timeInterval: TimeInterval
  private var failAllOperations: Bool
  
  init(timeInterval: TimeInterval,
       failAllOperations: Bool = false) {
    self.timeInterval = timeInterval
    self.failAllOperations = failAllOperations
    self.add(field: SportField(identifier: 0,
                               title: "CBC Teren fotbal",
                               description: "Teren sintetic minifotbal",
                               address: "Str. Bucuresti 6",
                               city: "Cluj-Napoca",
                               sport: .football))
    self.add(field: SportField(identifier: 1,
                               title: "CBC Teren tenis",
                               description: "Teren de tenis - zgura",
                               address: "Str. Bucuresti 6",
                               city: "Cluj-Napoca",
                               sport: .tennis))
  }
  
  func add(field: SportField) -> AnyPublisher<SportField, RepositoryError> {
    return Future<SportField, RepositoryError> { promise in
      DispatchQueue.main.asyncAfter(deadline: .now() + self.timeInterval, execute: {
        self.fields.append(field)
        promise(.success(field))
      })
    }
    .eraseToAnyPublisher()
  }
  
  func update(updatedField: SportField) -> AnyPublisher<SportField, RepositoryError> {
    return Future<SportField, RepositoryError> { promise in
      DispatchQueue.main.asyncAfter(deadline: .now() + self.timeInterval, execute: {
        guard !self.failAllOperations else {
          promise(.failure(.internalFailure))
          return
        }
        
        guard let index = self.fields.firstIndex(where: {field in
          return field == updatedField
        }) else {
          promise(.failure(.entryNotFound))
          return
        }
        
        self.fields[index] = updatedField
        promise(.success(updatedField))
      })
    }
    .eraseToAnyPublisher()
  }
  
  func delete(field: SportField) -> AnyPublisher<SportField, RepositoryError> {
    return Future<SportField, RepositoryError> { promise in
      DispatchQueue.main.asyncAfter(deadline: .now() + self.timeInterval, execute: {
        guard !self.failAllOperations else {
          promise(.failure(.internalFailure))
          return
        }
        
        guard let index = self.fields.firstIndex(where: { (existingItem) -> Bool in
          return existingItem == field
        }) else {
          promise(.failure(.entryNotFound))
          return
        }
        
        self.fields.remove(at: index)
        promise(.success(field))
      })
    }
    .eraseToAnyPublisher()
  }
  
  func getAllFieldsPublisher() -> AnyPublisher<[SportField], RepositoryError> {
    return Future<[SportField], RepositoryError> { promise in
      DispatchQueue.global(qos: .background).async {
        
        promise(.success(self.fields))
      }
    }
    .eraseToAnyPublisher()
  }
}
