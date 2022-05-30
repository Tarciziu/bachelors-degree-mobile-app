//
//  CreateReservationView.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 30.05.2022.
//

import SwiftUI

struct CreateReservationView: View {
  @State private var date = Date()
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
  
  var hours = ["09:00", "18:00", "19:00", "20:00"]
  @State private var selectedFrameworkIndex = 0
  
  init() {
    UITableView.appearance().backgroundColor = .clear
  }
  
  var body: some View {
    ZStack {
      Form {
        DatePicker("Ziua rezervarii",
                   selection: $date,
                   in: dateRange,
                   displayedComponents: .date)
          .datePickerStyle(.compact)
        Section {
          Picker(selection: $selectedFrameworkIndex, label: Text("Hour")) {
            ForEach(0 ..< hours.count) {
              Text(self.hours[$0])
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
    CreateReservationView()
  }
}
