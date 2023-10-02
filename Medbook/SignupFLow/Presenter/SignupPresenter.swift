//
//  SignupPresenter.swift
//  Medbook
//
//  Created by Kamal Negi on 02/10/23.
//

import Foundation

protocol SignupProtocol {
    func renderPassword(state: PasswordState)
    func getCurrentState() -> SignupState
    func renderPickerView(state: SignupState)
    func renderEmail(state: EmailState)
    func openHomeScreen()
    func showErrorToast(message: String)
}

struct SignupState {
    var countryList: CountryList?
    var emailState: EmailState?
    var passwordState: PasswordState?
    var isLetsgoBttonEnabled: Bool = true
}

struct EmailState {
    var email: String?
    var emailValidState: TextFieldsStatus = .none
    var emailError: String?
}

struct PasswordState {
    var password: String?
    var isMinCharsEntered: Bool = true
    var isSpecialCharPresent: Bool = true
    var isUpperCasePresent: Bool = true
    var isPasswordEntered: Bool = false
    var passwordError: String?
}

class SignupPresenter {
    var signupView: SignupProtocol?
    var mailArray = [String]()
    var passwordArray = [String]()
    
    init(signupView: SignupProtocol?) {
        self.signupView = signupView
        fetchCountryList()
    }
    
    func fetchCountryList() {
        if let url = URL(string: "https://api.first.org/data/v1/countries") {
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let sSelf = self, let view = sSelf.signupView else {
                    return
                }
                var state = view.getCurrentState()
                if let data = data {
                    let countryList = try? JSONDecoder().decode(CountryList.self, from: data)
                    state.countryList = countryList
                    DispatchQueue.main.async {
                        view.renderPickerView(state: state)
                    }
                }
            }
            task.resume()
        }
    }
    
    func checkForValidEmail(text: String?) {
        //check for valid email
        guard let view = self.signupView, let email = text else {
            return
        }
        var emailState = EmailState()
        if email.count > 0 {
            let isEmailValid = validateEmail(enteredEmail: email)
            emailState.email = email
            emailState.emailValidState = isEmailValid ? .valid : .invalid("Enter valid email")
            
        } else {
            emailState.emailValidState = .valid
        }
        DispatchQueue.main.async {
            view.renderEmail(state: emailState)
        }
    }
    
    func validateEmail(enteredEmail: String?) -> Bool {
        //valid email
        if let enteredEmail = enteredEmail {
            let emailFormat = ".*[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z].*"
            let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
            return emailPredicate.evaluate(with: enteredEmail)
        }
        return false
    }
    
    func checkForValidPassword(text: String?, isForLogin: Bool) {
        //check for valid password
        guard let view = self.signupView, let password = text else {
            
            return
        }
        var passwordState = PasswordState()
        passwordState.isPasswordEntered = password.count > 0 ? true : false
        if !isForLogin {
            passwordState.isMinCharsEntered = password.count >= 8 ? true : false
            passwordState.isSpecialCharPresent = isSpecialCharPresent(string: password)
            passwordState.isUpperCasePresent = isUperCasePresent(string: password)
        }
        passwordState.password = password
        
        DispatchQueue.main.async {
            view.renderPassword(state: passwordState)
        }
    }
    
    func isSpecialCharPresent(string: String) -> Bool {
        let regex = ".*[.*&^%$#@()/]+.*"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return emailPredicate.evaluate(with: string)
    }
    
    func isUperCasePresent(string: String) -> Bool {
        let regex = ".*[A-Z]+.*"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return emailPredicate.evaluate(with: string)
    }
    
    func primaryButtonTapped(isFromLogin: Bool) {
        //set the action when lets go button is tapped
        guard let view = self.signupView else {
            return
        }
        let state = view.getCurrentState()
        if isFromLogin {
            guard let details = UserProfileHelper.shared.fetchUserDetails() else {
                return
            }
            for detail in details {
                mailArray.append(detail["email"] as! String)
                passwordArray.append(detail["password"] as! String)
            }
            if let email = state.emailState?.email , let password = state.passwordState?.password, state.emailState?.emailValidState == .valid {
                if mailArray.contains(email) {
                    let mailIndex = mailArray.firstIndex(where: {$0 == email})
                    if passwordArray[mailIndex!] == password {
                        DispatchQueue.main.async {
                            view.openHomeScreen()
                        }
                    } else {
                        DispatchQueue.main.async {
                            view.showErrorToast(message: "Wrong Password")
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        view.showErrorToast(message: "No Account Found")
                    }
                }
            } else {
                if state.emailState?.email == nil {
                    DispatchQueue.main.async {
                        view.showErrorToast(message: "Please enter email")
                    }
                } else if state.emailState?.emailValidState != .valid {
                    DispatchQueue.main.async {
                        view.showErrorToast(message: "Please enter valid email")
                    }
                } else if state.passwordState?.password == nil {
                    DispatchQueue.main.async {
                        view.showErrorToast(message: "Please enter password")
                    }
                }
            }
        } else {
            UserProfileHelper.shared.createUserDetails(email: state.emailState?.email, password: state.passwordState?.password)
            DispatchQueue.main.async {
                view.openHomeScreen()
            }
        }
    }
}
