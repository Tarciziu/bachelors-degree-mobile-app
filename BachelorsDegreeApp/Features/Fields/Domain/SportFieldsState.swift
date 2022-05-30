//
//  SportFieldsState.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 29.05.2022.
//

import Foundation

class SportFieldsState: ObservableObject {
  @Published var sportsState: LoadingState<[SportField], RepositoryError> = .loading()
}
