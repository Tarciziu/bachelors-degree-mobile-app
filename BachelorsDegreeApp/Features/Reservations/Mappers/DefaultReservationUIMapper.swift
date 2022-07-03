//
//  DefaultReservationUIMapper.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 28.06.2022.
//

import Foundation

class DefaultReservationUIMapper: ReservationUIMapper {
  func convertToUIModel(from reservation: Reservation) -> ReservationUIModel {
    
    let sportFieldUIModel = DefaultSportFieldsUIMapper().convertToUIModel(from: reservation.sportField)
    
    let dateString = DateFormattersStore.domainDateFormatter.string(from: reservation.day)
    
    let hourString = "\(reservation.hour):00"
    
    let uiModel = ReservationUIModel(id: reservation.identifier,
                                     sportField: sportFieldUIModel,
                                     date: dateString,
                                     hour: hourString)
    return uiModel
  }
  
  func convertToUIModel(from reservations: [Reservation]) -> [ReservationUIModel] {
    reservations.map { convertToUIModel(from: $0) }
  }
}
