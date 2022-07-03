//
//  BachelorsDegreeAppApp.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 06.05.2022.
//

import SwiftUI
import Alamofire
import CoreLocation

class SportFieldsDependencies: ObservableObject {
  private(set) var state: SportFieldsState
  private(set) var service: SportFieldsService
  private(set) var mapper: SportFieldsUIMapper
  private(set) var geocoder: CLGeocoder
  
  
  init(state: SportFieldsState,
       service: SportFieldsService,
       mapper: SportFieldsUIMapper,
       geocoder: CLGeocoder) {
    self.state = state
    self.service = service
    self.mapper = mapper
    self.geocoder = geocoder
  }
}

class ReservationsDependencies: ObservableObject {
  private(set) var state: ReservationsState
  private(set) var service: ReservationService
  private(set) var mapper: ReservationUIMapper
  private(set) var geocoder: CLGeocoder
  
  
  init(state: ReservationsState,
       service: ReservationService,
       mapper: ReservationUIMapper,
       geocoder: CLGeocoder) {
    self.state = state
    self.service = service
    self.mapper = mapper
    self.geocoder = geocoder
  }
}

@main
struct BachelorsDegreeAppApp: App {
  private var sportFieldsDependencies: SportFieldsDependencies = {
    let session: Alamofire.Session = .default
    
    let dtoMapper = DefaultSportFieldsDTOMapper()
    
    let repository = RealSportFieldsRepository(session: session,
                                               mapper: dtoMapper)
    
    let mockedRepository = MockedSportFieldsRepository(timeInterval: 1.0,
                                                       failAllOperations: false)
    let state = SportFieldsState()
    let service = DefaultSportFieldsService(sportFieldsState: state,
                                            fieldsRepository: repository)
    
    let mapper = DefaultSportFieldsUIMapper()
    let geocoder = CLGeocoder()
    return SportFieldsDependencies(state: state,
                                   service: service,
                                   mapper: mapper,
                                   geocoder: geocoder)
  }()
  
  private var reservationsDependencies: ReservationsDependencies = {
    let session: Alamofire.Session = .default
    
    let dtoMapper = DefaultReservationDTOMapper()
    
    let repository = RealReservationRepository(session: session,
                                               mapper: dtoMapper)
    
    let mockedRepository = MockedReservationRepository(timeInterval: 1.0,
                                                       failAllOperations: false)
    let state = ReservationsState()
    let service = DefaultReservationService(reservationState: state,
                                            reservationRepository: repository)
    
    let mapper = DefaultReservationUIMapper()
    let geocoder = CLGeocoder()
    return ReservationsDependencies(state: state,
                                    service: service,
                                    mapper: mapper,
                                    geocoder: geocoder)
  }()
  
  var body: some Scene {
    WindowGroup {
      MainLandingView()
        .environmentObject(sportFieldsDependencies)
        .environmentObject(reservationsDependencies)
    }
  }
}
