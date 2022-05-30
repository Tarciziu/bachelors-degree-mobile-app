//
//  MainLandingView.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 07.05.2022.
//

import SwiftUI

struct MainLandingView: View {
  @EnvironmentObject var sportFieldsDependencies: SportFieldsDependencies
  @StateObject var authentication = Authentication()
  var body: some View {
    if authentication.isValidated {
      TabView {
        FieldsListView(viewModel: SportFieldsViewModel(service: sportFieldsDependencies.service,
                                                        state: sportFieldsDependencies.state,
                                                        mapper: sportFieldsDependencies.mapper))
          .tabItem {
            Label("Terenuri de sport", image: "MyReservations")
          }
        Text("My reservations")
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
