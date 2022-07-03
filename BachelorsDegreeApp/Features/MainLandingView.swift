//
//  MainLandingView.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 07.05.2022.
//

import SwiftUI

struct MainLandingView: View {
  @EnvironmentObject var sportFieldsDependencies: SportFieldsDependencies
  @EnvironmentObject var reservationDependencies: ReservationsDependencies
  @StateObject var authentication = Authentication()
  var body: some View {
    if authentication.isValidated {
      TabView {
        FieldsListView(viewModel: SportFieldsViewModel(service: sportFieldsDependencies.service,
                                                       state: sportFieldsDependencies.state,
                                                       mapper: sportFieldsDependencies.mapper,
                                                       loggedUserId: authentication.email))
          .tabItem {
            Label("Terenuri de sport", image: "MyReservations")
          }
        ReservationsListView(viewModel: ReservationsViewModel(service: reservationDependencies.service,
                                                              state: reservationDependencies.state,
                                                              mapper: reservationDependencies.mapper,
                                                              loggedUserId: authentication.email))
          .tabItem {
            Label("Rezervarile mele", image: "MyReservations")
          }
      }
    } else {
      LoginView()
        .environmentObject(authentication)
    }
  }
}

struct MainLandingView_Previews: PreviewProvider {
  static var previews: some View {
    MainLandingView()
  }
}
