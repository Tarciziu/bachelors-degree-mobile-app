//
//  FieldsListView.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 07.05.2022.
//

import SwiftUI

struct FieldsListView: View {
  @StateObject var viewModel: SportFieldsViewModel
  @EnvironmentObject var dependencies: SportFieldsDependencies
  @EnvironmentObject var reservationDependencies: ReservationsDependencies
  @State private var searchText = ""
  @State var isPresentingDetails = false
  // TODO: move this to presentation layer
  @State var showFilters = false
  
  var body: some View {
    NavigationView {
      VStack {
        Text("Gologan Christin-Tarciziu")
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
          .alert(isPresented: .constant(viewModel.presentationState.isFailed),
                 error: viewModel.presentationState.failureReason,
                 actions: { _ in
            Button("OK", role: .cancel) { }
          },
                 message: { error in
            Text(error.failureReason ?? String())
            
          })
      }
      .navigationTitle(viewModel.listTitle)
      .background(ColorsCatalog.listBackground)
    }
    .navigationViewStyle(.stack)
  }
  private func listView(with fields: [SportFieldUIModel]) -> some View {
    var selectedItem = -1
    return ScrollView {
      VStack(alignment: .leading, spacing: 16.0) {
        ForEach(fields, id: \.self) { item in
          FieldCard(model: item)
            .onTapGesture {
              selectedItem = item.id
              debugPrint("\(selectedItem)")
              isPresentingDetails.toggle()
            }
        }
        NavigationLink(destination: FieldDetailsScreen(viewModel: SportFieldDetailsViewModel(service: dependencies.service,
                                                                                             state: dependencies.state,
                                                                                             mapper: dependencies.mapper,
                                                                                             reservationsState: reservationDependencies.state,
                                                                                             reservationService: reservationDependencies.service,
                                                                                             geocoder: dependencies.geocoder, fieldID: selectedItem,
                                                                                             loggedUserId: viewModel.loggedUserId)),
                       isActive: $isPresentingDetails) {
          EmptyView()
        }
      }
      .padding(.horizontal, 24.0)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .overlay {
      if fields.isEmpty {
        Text("Empty list text")
          .padding(24.0)
      }
    }
  }
}

struct FieldsListView_Previews: PreviewProvider {
  static var previews: some View {
    let repository = MockedSportFieldsRepository(timeInterval: 3.0,
                                                 failAllOperations: false)
    let state = SportFieldsState()
    let service = DefaultSportFieldsService(sportFieldsState: state,
                                            fieldsRepository: repository)
    let mapper = DefaultSportFieldsUIMapper()
    let loggedUserId = ""
    let viewModel = SportFieldsViewModel(service: service,
                                         state: state,
                                         mapper: mapper,
                                         loggedUserId: loggedUserId)
    FieldsListView(viewModel: viewModel)
  }
}
