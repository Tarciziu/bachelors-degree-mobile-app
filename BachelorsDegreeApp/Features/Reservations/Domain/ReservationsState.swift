//
//  ReservationsState.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 30.05.2022.
//

import Foundation

class ReservationsState: ObservableObject {
  @Published var reservationsState: LoadingState<[Reservation], RepositoryError> = .loading()
}
