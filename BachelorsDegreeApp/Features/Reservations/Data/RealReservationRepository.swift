//
//  RealReservationRepository.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 28.06.2022.
//

import Foundation
import Combine
import Alamofire

class RealReservationRepository: ReservationRepository {
  // MARK: - Dependencies
  
  private let session: Alamofire.Session
  private let mapper: ReservationDTOMapper
  
  // MARK: - Configuration

  private let baseURL = "http://localhost:8080/"
  
  // MARK: - Init
  
  init(session: Alamofire.Session,
       mapper: ReservationDTOMapper) {
    self.session = session
    self.mapper = mapper
  }
  
  func add(reservation: Reservation, userId: String) -> AnyPublisher<Reservation, RepositoryError> {
    let reservationDTO = mapper.convertToDTO(from: reservation, userId: userId)
    let reservationURL = "\(baseURL)user/reservation"
    return session.request(reservationURL,
                           method: .post,
                           parameters: reservationDTO,
                           encoder: JSONParameterEncoder.default)
      .validate()
      .publishDecodable(type: ReservationDTOs.ReservationResponse.self)
      .tryCustomMap(mapper.convertToReservation)
      .eraseToAnyPublisher()
  }
  
  func update(updatedReservation: Reservation) -> AnyPublisher<Reservation, RepositoryError> {
    let updateURL = "\(baseURL)"
    debugPrint(updateURL)
    return session.request(updateURL,
                           method: .put,
                           parameters: updatedReservation.identifier,
                           encoder: JSONParameterEncoder.default)
      .validate()
      .publishDecodable()
      .tryCustomMap(mapper.convertToReservation)
      .eraseToAnyPublisher()
  }
  
  func delete(reservation: Reservation) -> AnyPublisher<Reservation, RepositoryError> {
    let deleteURL = "\(baseURL)"
    return session.request(deleteURL, method: .delete)
          .validate()
          .publishDecodable(type: ReservationDTOs.ReservationResponse.self)
          .tryCustomMap(mapper.convertToReservation)
          .eraseToAnyPublisher()
  }
  
  func getAllReservations(userId: String) -> AnyPublisher<[Reservation], RepositoryError> {
    let getAllReservationsURL = "\(baseURL)user/\(userId)/reservations"
    debugPrint(getAllReservationsURL)
    return session.request(getAllReservationsURL, method: .get)
      .validate()
      .publishDecodable(type: [ReservationDTOs.ReservationResponse].self)
      .tryCustomMap(mapper.convertToReservationsArray)
      .eraseToAnyPublisher()
  }
  
  
}

