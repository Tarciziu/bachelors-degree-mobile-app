//
//  DefaultReservationDTOMapper.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 28.06.2022.
//

import Foundation

class DefaultReservationDTOMapper: ReservationDTOMapper {
  
  func convertToReservation(from reservationDTO: ReservationDTOs.ReservationResponse) -> Reservation {
    let sportField = DefaultSportFieldsDTOMapper().convertToSportField(from: reservationDTO.sportField)
    
    var date = Date.now
    
    if let validDate = DateFormattersStore.domainDateFormatter.date(from: reservationDTO.day) {
      date = validDate
    }
    
    
    let reservation = Reservation(identifier: reservationDTO.id,
                                  sportField: sportField,
                                  day: date,
                                  hour: reservationDTO.hour)
    return reservation
  }
  
  func convertToReservationsArray(from reservationDTOs: [ReservationDTOs.ReservationResponse]) -> [Reservation] {
    reservationDTOs.map { convertToReservation(from: $0) }
  }
  
  func convertToDTO(from reservation: Reservation, userId: String) -> ReservationDTOs.ReservationRequest {
    
    let dateStr = DateFormattersStore.domainDateFormatter.string(from: reservation.day)
    
    let dto = ReservationDTOs.ReservationRequest(userID: userId,
                                                 sportFieldId: reservation.sportField.identifier,
                                                 day: dateStr,
                                                 hour: reservation.hour)
    
    return dto
  }
  
  
}
