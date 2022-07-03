//
//  RealSportFieldsRepository.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 30.05.2022.
//

import Foundation
import Combine
import Alamofire

class RealSportFieldsRepository: SportFieldsRepository {
  
  // MARK: - Dependencies
  
  private let session: Alamofire.Session
  private let mapper: SportFieldsDTOMapper
  
  // MARK: - Configuration
  
  private let baseURL = "http://localhost:8080/sportfields"
  private let loggedUserIdentifier = "tarciziu99christin@yahoo.com"
  
  // MARK: - Init
  
  init(session: Alamofire.Session,
       mapper: SportFieldsDTOMapper) {
    self.session = session
    self.mapper = mapper
  }
  
  func add(field: SportField) -> AnyPublisher<SportField, RepositoryError> {
    let fieldDTO = mapper.convertToDTO(from: field)
    return session.request(baseURL,
                           method: .post,
                           parameters: fieldDTO,
                           encoder: JSONParameterEncoder.default)
      .validate()
      .publishDecodable(type: SportFieldsDTOs.FieldResponse.self)
      .tryCustomMap(mapper.convertToSportField)
      .eraseToAnyPublisher()
  }
  
  func update(updatedField: SportField) -> AnyPublisher<SportField, RepositoryError> {
    let updateURL = "\(baseURL)\(updatedField.identifier)"
    debugPrint(updateURL)
    return session.request(updateURL,
                           method: .put,
                           parameters: loggedUserIdentifier,
                           encoder: JSONParameterEncoder.default)
      .validate()
      .publishDecodable()
      .tryCustomMap(mapper.convertToSportField)
      .eraseToAnyPublisher()
  }
  
  func delete(field: SportField) -> AnyPublisher<SportField, RepositoryError> {
    let deleteURL = "\(baseURL)\(field.identifier)"
    return session.request(deleteURL, method: .delete)
          .validate()
          .publishDecodable(type: SportFieldsDTOs.FieldResponse.self)
          .tryCustomMap(mapper.convertToSportField)
          .eraseToAnyPublisher()
  }
  
  func convertToInt(_ values: SportFieldsDTOs.ValidHours) -> [Int] {
    let values = values.hours.split(separator: "-")
    var hours: [Int] = []
    
    for h in values {
      if let validHour = Int(h) {
        hours.append(validHour)
      }
    }
    
    return hours
  }
  
  func getValidHours(fieldID: Int, dateStr: String) -> AnyPublisher<[Int], RepositoryError> {
    let validHoursURL = "\(baseURL)/schedule?sportFieldId=\(fieldID)&date=\(dateStr)"
    debugPrint(validHoursURL)
    return session.request(validHoursURL, method: .get)
          .validate()
          .publishDecodable(type: SportFieldsDTOs.ValidHours.self)
          .tryCustomMap(convertToInt)
          .eraseToAnyPublisher()
  }
  
  func getAllFieldsPublisher() -> AnyPublisher<[SportField], RepositoryError> {
    //let getAllEventsURL = "\(baseURL)?userId=\(loggedUserIdentifier)"
    return session.request(baseURL, method: .get)
      .validate()
      .publishDecodable(type: [SportFieldsDTOs.FieldResponse].self)
      .tryCustomMap(mapper.convertToSportFieldsArray)
      .eraseToAnyPublisher()
  }
  

}
