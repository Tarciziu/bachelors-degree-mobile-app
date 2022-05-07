//
//  MainLandingView.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 07.05.2022.
//

import SwiftUI

struct MainLandingView: View {
  @StateObject var authentication = Authentication()
  var body: some View {
    if authentication.isValidated {
      Text("Authenticated")
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
