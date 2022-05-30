//
//  ReservationsState.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 30.05.2022.
//

import Foundation

class ReservationsState: ObservableObject {
  @Published var sportsState: LoadingState<[Reservation], RepositoryError> = .loading()
}
