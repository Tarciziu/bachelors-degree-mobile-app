//
//  AlamofireDataResponsePublisherExtension.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 30.05.2022.
//

import Foundation
import Alamofire
import Combine

extension Alamofire.DataResponsePublisher {
  func tryCustomMap<T>(_ transform: @escaping (Value) throws -> T) -> AnyPublisher<T, RepositoryError> {
    return self.tryMap { (dataResponse) -> T in
      switch dataResponse.result {
      case .success(let dtos):
        return try transform(dtos)
      case .failure(let error):
        guard let data = dataResponse.data else {
          throw error
        }
        guard let decoded = try? JSONDecoder().decode(ServerErrorDTO.self, from: data) else {
          throw error
        }
        throw RepositoryError.serverError(decoded.message)
      }
    }.mapError { error in
      guard let err = error as? RepositoryError else {
        return RepositoryError.serverError(error.localizedDescription)
      }
      return err
    }
    .eraseToAnyPublisher()
  }
}
