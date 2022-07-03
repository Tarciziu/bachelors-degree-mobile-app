//
//  CreateReservationView.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 30.05.2022.
//

import SwiftUI
import CoreLocation

struct CreateReservationView: View {
  @State private var date = Date()
  @StateObject var viewModel: SportFieldDetailsViewModel
  @Binding var showState: Bool
  
  let dateRange: ClosedRange<Date> = {
    let calendar = Calendar.current
    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date.now)
    let aMonthInFuture = Calendar.current.date(byAdding: .day, value: 30, to: Date.now)
    var year = 2022
    var month = 5
    var monthInFuture = 6
    var day = 20
    var dayInFuture = 26
    
    if let tomorrow = tomorrow {
      year = Calendar.current.component(.year, from: tomorrow)
      month = Calendar.current.component(.month, from: tomorrow)
      day = Calendar.current.component(.day, from: tomorrow)
    }
    
    if let aMonthInFuture = aMonthInFuture {
      year = Calendar.current.component(.year, from: aMonthInFuture)
      monthInFuture = Calendar.current.component(.month, from: aMonthInFuture)
      dayInFuture = Calendar.current.component(.day, from: aMonthInFuture)
    }
    
    let startComponents = DateComponents(year: year, month: month, day: day)
    let endComponents = DateComponents(year: year, month: monthInFuture, day: dayInFuture)
    return calendar.date(from:startComponents)!
    ...
    calendar.date(from:endComponents)!
  }()
  
  @State private var selectedFrameworkIndex = 0
  
  @State var hours: [Int] = []
  
  var body: some View {
    UITableView.appearance().backgroundColor = .clear
    return ZStack {
      Form {
        DatePicker("Ziua rezervarii",
                   selection: $date,
                   in: dateRange,
                   displayedComponents: .date)
          .onChange(of: date, perform: {value in
            debugPrint("value \(value)")
            debugPrint("date \(date)")
            self.hours = viewModel.getHours(date: date)
            debugPrint("date \(date)")
            debugPrint(hours)
          })
          .datePickerStyle(.compact)
        Section {
          Picker(selection: $selectedFrameworkIndex, label: Text("Hour")) {
            ForEach(hours, id: \.self) { hour in
              Text("\(hour):00")
            }
          }
        }
      }
      .background(Color.white)
      
      floatingButton()
    }
    .padding(24.0)
  }
  
  private func floatingButton() -> some View {
    return FloatingButton(text: "Reserve",
                          action: {
      viewModel.handleCreateReservationButtonPress(date: date,
                                                   hour: selectedFrameworkIndex)
      showState = false
      viewModel.updateReservations()
    },
                          maxHeight: 50.0,
                          foregroundColor: .white,
                          font: FontsCatalog.confirmationButton,
                          clipShape: RoundedRectangle(cornerRadius: 12.0),
                          backgroundColor: ColorsCatalog.accent)
      .padding(.horizontal, 26.0)
      .padding(.bottom, 12.0)
  }
}

struct CreateReservationView_Previews: PreviewProvider {
  static var previews: some View {
    let repository = MockedSportFieldsRepository(timeInterval: 3.0,
                                                 failAllOperations: false)
    let state = SportFieldsState()
    let service = DefaultSportFieldsService(sportFieldsState: state,
                                            fieldsRepository: repository)
    let mapper = DefaultSportFieldsUIMapper()
    let geocoder = CLGeocoder()
    
    let resState = ReservationsState()
    
    let resService = DefaultReservationService(reservationState: resState,
                                               reservationRepository: MockedReservationRepository(timeInterval: 1.0))
    
    let viewModel = SportFieldDetailsViewModel(service: service,
                                               state: state,
                                               mapper: mapper,
                                               reservationsState: resState,
                                               reservationService: resService,
                                               geocoder: geocoder,
                                               fieldID: 1,
                                               loggedUserId: "mail@mail.com")
    
    //CreateReservationView(viewModel: viewModel, showState: showState)
  }
}
