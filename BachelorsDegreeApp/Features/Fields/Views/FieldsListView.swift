//
//  FieldsListView.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 07.05.2022.
//

import SwiftUI

struct FieldsListView: View {
  @State private var searchText = ""
  @State var isPresentingDetails = false
  // TODO: move this to presentation layer
  @State var showFilters = false
  
  var body: some View {
    NavigationView {
      VStack {
        listView(with: ["a", "b", "c", "d", "f", "h", "i"])
      }
      .navigationTitle("Sport fields")
      .searchable(text: $searchText,
                  placement: .navigationBarDrawer(displayMode: .always),
                  prompt: "Search input...")
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
  private func listView(with fields: [String]) -> some View {
    var selectedItem = ""
    return ScrollView {
      VStack(alignment: .leading, spacing: 16.0) {
        ForEach(fields, id: \.self) { item in
          FieldCard()
            .onTapGesture {
              selectedItem = item
              isPresentingDetails.toggle()
            }
        }
        NavigationLink(destination: Text(selectedItem+"s"),
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
    FieldsListView()
  }
}
