//
//  SportFieldUIModel.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 29.05.2022.
//

import Foundation

struct SportFieldUIModel: Hashable {
  let id: Int
  let title: String
  let description: String
  let image: ImageSource
  let address: String
  var link: URL?
  let city: String
}
