//
//  ReservationsListView.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 28.06.2022.
//

import SwiftUI

struct ReservationsListView: View {
  @StateObject var viewModel: ReservationsViewModel
  @EnvironmentObject var dependencies: ReservationsDependencies
  @State private var searchText = ""
  @State var isPresentingDetails = false
  
  var body: some View {
    NavigationView {
      VStack {
        listView(with: viewModel.presentationState.currentValue ?? [])
          .disabled(viewModel.presentationState.isLoading)
          .overlay {
            if viewModel.presentationState.isLoading {
              ProgressView()
                .frame(maxWidth: .infinity,
                       maxHeight: .infinity)
                .background(ColorsCatalog.listBackground)
            }
          }
      }
      .navigationTitle(viewModel.listTitle)
      .toolbar {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
          Button {
            viewModel.fetchFields()
          }
        label: {
          Image(systemName: "arrow.triangle.2.circlepath.circle")
            .foregroundColor(ColorsCatalog.primaryText)
        }
        .accentColor(ColorsCatalog.primaryText)
        }
      }
      .background(ColorsCatalog.listBackground)
    }
    .navigationViewStyle(.stack)
  }
  
  private func listView(with reservations: [ReservationUIModel]) -> some View {
    var selectedItem = -1
    return ScrollView {
      VStack(alignment: .leading, spacing: 16.0) {
        ForEach(reservations, id: \.self) { item in
          ReservationCard(model: item)
            .onTapGesture {
              selectedItem = item.id
              debugPrint("\(selectedItem)")
              isPresentingDetails.toggle()
            }
        }
        NavigationLink(destination: ReservationDetailsScreen(viewModel: ReservationDetailsViewModel(service: dependencies.service,
                                                                                                    state: dependencies.state,
                                                                                                    mapper: dependencies.mapper,
                                                                                                    geocoder: dependencies.geocoder,
                                                                                                    reservationID: selectedItem)),
                       isActive: $isPresentingDetails) {
          EmptyView()
        }
      }
      .padding(.horizontal, 24.0)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .overlay {
      if reservations.isEmpty {
        Text("Empty list text")
          .padding(24.0)
      }
    }
  }
}

struct ReservationsListView_Previews: PreviewProvider {
  static var previews: some View {
    let repository = MockedReservationRepository(timeInterval: 3.0,
                                                 failAllOperations: false)
    let state = ReservationsState()
    let service = DefaultReservationService(reservationState: state,
                                            reservationRepository: repository )
    let mapper = DefaultReservationUIMapper()
    let loggedUserId = ""
    let viewModel = ReservationsViewModel(service: service,
                                          state: state,
                                          mapper: mapper,
                                          loggedUserId: loggedUserId)
    ReservationsListView(viewModel: viewModel)
  }
}

