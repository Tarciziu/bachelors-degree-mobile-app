//
//  DateFormatterExtension.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 28.06.2022.
//

import Foundation

extension DateFormatter {
  static let domainDateTimeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }()
}
