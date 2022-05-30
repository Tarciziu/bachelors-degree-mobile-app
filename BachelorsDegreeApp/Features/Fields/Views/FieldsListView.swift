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
  @State private var searchText = ""
  @State var isPresentingDetails = false
  // TODO: move this to presentation layer
  @State var showFilters = false
  
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
      .searchable(text: $searchText,
                  placement: .navigationBarDrawer(displayMode: .always),
                  prompt: viewModel.searchbarHintText)
      .toolbar {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
          Button {
            showFilters = true
          }
        label: {
          Image("Filter")
        }
        .accentColor(ColorsCatalog.primaryText)
        }
      }
      .background(ColorsCatalog.listBackground)
      .sheet(isPresented: $showFilters) {
        NavigationView {
          Text("Filters")
            .toolbar {
              Button {
                self.showFilters.toggle()
              } label: {
                Image("Close")
              }
              .foregroundColor(ColorsCatalog.primaryText)
            }
        }
      }
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
                                                                                             geocoder: dependencies.geocoder, fieldID: selectedItem)),
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
    let viewModel = SportFieldsViewModel(service: service,
                                         state: state,
                                         mapper: mapper)
    FieldsListView(viewModel: viewModel)
  }
}
