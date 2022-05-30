//
//  ImageSource.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 29.05.2022.
//

import Foundation

enum ImageSource: Hashable {
  case url(URL)
  case asset(String)
  case system(String)
  case placeholder
}
