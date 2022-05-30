//
//  ProgressIndicator.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 30.05.2022.
//

import SwiftUI

struct ProgressIndicator: View {
  var body: some View {
    ProgressView()
      .frame(maxWidth: 100.0,
             maxHeight: 100.0)
      .background(ColorsCatalog.listBackground)
      .cornerRadius(20.0)
      .overlay(
        RoundedRectangle(cornerRadius: 20.0, style: .continuous)
          .stroke(ColorsCatalog.listItemBorder, lineWidth: 1.0))
  }
}

struct ProgressIndicator_Previews: PreviewProvider {
  static var previews: some View {
    ProgressIndicator()
  }
}
