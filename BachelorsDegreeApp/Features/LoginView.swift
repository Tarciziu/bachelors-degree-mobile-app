//
//  LoginView.swift
//  BachelorsDegreeApp
//
//  Created by Tarciziu Gologan on 06.05.2022.
//

import SwiftUI

struct LoginView: View {
  @EnvironmentObject var authentication: Authentication
  
  @State var username: String = ""
  @State var password: String = ""
  
  let loginImageString = "Login"
  let loginButtonText = "LOGIN"
  let emailText = "E-mail"
  let passwordText = "Password"
  
  var body: some View {
    VStack {
      loginImage
      emailTextField
      passwordTextField
      Button(action: {
      // TODO: ADD HANDLER FOR LOGIN
        authentication.updateValidation(success: true)
      }) {
        loginButtonContent
      }
    }
    .padding()
  }
  
  @ViewBuilder private var loginImage: some View {
    Image(loginImageString)
      .resizable()
      .scaledToFill()
      .clipped()
      .frame(width: 150.0, height: 150.0)
      .padding(.bottom, 50.0)
  }
  
  @ViewBuilder private var emailTextField: some View {
    TextField(emailText, text: $username)
      .padding()
      .font(FontsCatalog.inputText)
      .background(ColorsCatalog.inputTextFieldBackground)
      .cornerRadius(5.0)
      .padding(.bottom, 20)
  }
  
  @ViewBuilder private var passwordTextField: some View {
    SecureField(passwordText, text: $password)
      .padding()
      .font(FontsCatalog.inputText)
      .background(ColorsCatalog.inputTextFieldBackground)
      .cornerRadius(5.0)
      .padding(.bottom, 20)
  }
  
  @ViewBuilder private var loginButtonContent: some View {
    Text(loginButtonText)
      .padding()
      .font(FontsCatalog.confirmationButton)
      .foregroundColor(.white)
      .frame(width: 220, height: 60)
      .background(ColorsCatalog.accent)
      .cornerRadius(15.0)
  }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    LoginView()
  }
}
