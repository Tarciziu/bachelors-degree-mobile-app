//
//  Authentication.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 07.05.2022.
//

import Foundation

class Authentication: ObservableObject {
  @Published var isValidated = false
  @Published var email = ""
  
  enum AuthenticationError: Error, LocalizedError, Identifiable {
    case invalidCredentials
    
    var id: String {
      self.localizedDescription
    }
    
    var errorDescription: String? {
      switch self {
      case .invalidCredentials:
        return "Either your email or password are incorrect. Please try again"
      }
    }
  }
  
  func updateValidation(success: Bool) {
    isValidated = success
  }
  
  func updateEmail(email: String) {
    self.email = email
  }
}
