//
//  SignupViewController.swift
//  Medbook
//
//  Created by Kamal Negi on 01/10/23.
//

import UIKit

class SignupViewController: UIViewController {

    
    @IBOutlet weak var welcomeText: UILabel! {
        didSet {
            welcomeText.textColor = .black
            welcomeText.font = UIFont.degularBold(UIFont.Size.size_32)
        }
    }
    
    @IBOutlet weak var emailTextView: TextFields! {
        didSet {
            emailTextView.placeholder = "Email"
            emailTextView.type = .email
            emailTextView.status = .valid
            emailTextView.autocapitalizationType = .none
            emailTextView.becomeFirstResponder()
            emailTextView.addTarget(self, action: #selector(emailFieldEdited), for: .editingChanged)
        }
    }
    
    @IBOutlet weak var passwordTextView: TextFields! {
        didSet {
            passwordTextView.status = .valid
            passwordTextView.type = .password
            passwordTextView.placeholder = "Password"
            passwordTextView.autocapitalizationType = .none
            passwordTextView.textContentType = .oneTimeCode
            passwordTextView.addTarget(self, action: #selector(passwordFieldEdited), for: .editingChanged)
        }
    }
    
    @IBOutlet weak var minCharCheckbox: UIImageView! {
        didSet {
            minCharCheckbox.image = UIImage(named: "checkboxUnchecked")
        }
    }
    
    @IBOutlet weak var minCharText: UILabel! {
        didSet {
            minCharText.text = "At least 8 characters"
        }
    }
    
    @IBOutlet weak var upperCaseCheckbox: UIImageView! {
        didSet {
            upperCaseCheckbox.image = UIImage(named: "checkboxUnchecked")
        }
    }
    
    @IBOutlet weak var upperCaseText: UILabel! {
        didSet {
            upperCaseText.text = "Must contain an uppercase letter"
        }
    }
    
    @IBOutlet weak var specialCharCheckbox: UIImageView! {
        didSet{
            specialCharCheckbox.image = UIImage(named: "checkboxUnchecked")
        }
    }
    
    @IBOutlet weak var specialCharText: UILabel! {
        didSet {
            specialCharText.text = "Contains a special character"
        }
    }
    
    @IBOutlet weak var countryPickerView: UIPickerView! {
        didSet {
            countryPickerView.dataSource = self
            countryPickerView.delegate = self
        }
    }
    
    @IBOutlet weak var letsGoButton: UIButton! {
        didSet {
            letsGoButton.setTitle("Let's Go", for: .normal)
            letsGoButton.layer.borderWidth = 1
            letsGoButton.layer.borderColor = UIColor.black.cgColor
            letsGoButton.setTitleColor(.gray, for: .normal)
            letsGoButton.layer.cornerRadius = 12
            letsGoButton.setImage(UIImage(named: "rightArrow"), for: .normal)
            letsGoButton.semanticContentAttribute = .forceRightToLeft
            letsGoButton.addTarget(self, action: #selector(letsGoButtonTapped), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var passWordValidaterView: UIStackView!
        
    var isForLogin: Bool = false
    var presenter: SignupPresenter?
    var currentState: SignupState = SignupState()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupInitialView()
        setupPresenter()
        self.view.backgroundColor = UIColor.colorFromHexString(hexString: "#FFFFFF")
        setupBackgroundImage()
        isLetsGoButtonEnabled()
        addtapGestures()
    }
    
    @objc func letsGoButtonTapped() {
        presenter?.primaryButtonTapped(isFromLogin: isForLogin)
    }

    func setupInitialView() {
        if isForLogin {
            passWordValidaterView.isHidden = true
            countryPickerView.isHidden = true
            welcomeText.attributedText = NSAttributedString(string: "Welcome \nsignup to continue")
        } else {
            passWordValidaterView.isHidden = false
            countryPickerView.isHidden = false
            welcomeText.attributedText = NSAttributedString(string: "Welcome,\nlogin to continue")
        }
    }
    
    func setupBackgroundImage() {
        if let backgroundImage = UIImage(named: "shape") {
            var imageView : UIImageView!
            imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
            imageView.contentMode =  .scaleToFill
            imageView.clipsToBounds = true
            imageView.image = backgroundImage
            imageView.center = view.center
            view.addSubview(imageView)
            self.view.sendSubviewToBack(imageView)
        }
    }
    
    func addtapGestures() {
        let dismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(dimissKeyboard))
        self.view.addGestureRecognizer(dismissKeyboard)
    }
    
    @objc func dimissKeyboard() {
        view.endEditing(true)
    }
    func setupPresenter() {
        presenter = SignupPresenter(signupView: self)
    }
    
    func setupEmailTextField() {
        let state = currentState.emailState
        emailTextView.status = state?.emailValidState ?? .invalid("Enter Valid State")
    }
    
    func setupPasswordTextField() {
        //set up different checkboxes state
        let state = currentState.passwordState
        if state?.isPasswordEntered == true {
            if state?.isMinCharsEntered == false {
                minCharCheckbox.image = UIImage(named: "redCheckboxUnchecked")
                minCharText.textColor = .red
                passwordTextView.status = .invalid("")
            } else {
                minCharCheckbox.image = UIImage(named: "checkboxFilled")
                minCharText.textColor = .black
                passwordTextView.status = .valid
            }
            
            if state?.isUpperCasePresent == false {
                upperCaseCheckbox.image = UIImage(named: "redCheckboxUnchecked")
                upperCaseText.textColor = .red
                passwordTextView.status = .invalid("")
            } else {
                upperCaseCheckbox.image = UIImage(named: "checkboxFilled")
                upperCaseText.textColor = .black
                passwordTextView.status = .valid
            }
            
            if state?.isSpecialCharPresent == false {
                specialCharCheckbox.image = UIImage(named: "redCheckboxUnchecked")
                specialCharText.textColor = .red
                passwordTextView.status = .invalid("")
            } else {
                specialCharCheckbox.image = UIImage(named: "checkboxFilled")
                specialCharText.textColor = .black
                passwordTextView.status = .valid
            }
        } else {
            minCharCheckbox.image = UIImage(named: "checkboxUnchecked")
            minCharText.textColor = .black
            passwordTextView.status = .valid
            upperCaseCheckbox.image = UIImage(named: "checkboxUnchecked")
            upperCaseText.textColor = .black
            specialCharCheckbox.image = UIImage(named: "checkboxUnchecked")
            specialCharText.textColor = .black
        }
    }
    
    func isLetsGoButtonEnabled() {
        //set primary button enable state
        guard !isForLogin else {
            return
        }
        let isEmailValid = currentState.emailState?.emailValidState == .valid ? true : false
        let isPasswordValid = currentState.passwordState?.isPasswordEntered == true &&
        currentState.passwordState?.isUpperCasePresent == true &&
        currentState.passwordState?.isSpecialCharPresent == true &&
        currentState.passwordState?.isMinCharsEntered == true ? true : false
        
        if isEmailValid && isPasswordValid {
            letsGoButton.layer.borderColor = UIColor.black.cgColor
            letsGoButton.isUserInteractionEnabled = true
        } else {
            letsGoButton.layer.borderColor = UIColor.gray.cgColor
            letsGoButton.isUserInteractionEnabled = false
        }
    }
}

extension SignupViewController: SignupProtocol {
    func openHomeScreen() {
        UserDefaults.standard.set(true, forKey: "userLoggedIn")
        navigationController?.popViewController(animated: true)
        let viewController = UIStoryboard(name: "HomeViewController", bundle: .main).instantiateViewController(identifier: "HomeViewController")
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showErrorToast(message: String) {
        //create alert in case of error
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func renderPassword(state: PasswordState) {
        //render passsword text field
        currentState.passwordState = state
        setupPasswordTextField()
        isLetsGoButtonEnabled()
    }
    
    func getCurrentState() -> SignupState {
        //used to get the current state
        return currentState
    }
    
    func renderPickerView(state: SignupState) {
        //used to render the picker data after api call
        currentState = state
        countryPickerView.reloadAllComponents()
    }
    
    func renderEmail(state: EmailState) {
        //user to render email text field
        currentState.emailState = state
        isLetsGoButtonEnabled()
        setupEmailTextField()
    }
}

extension SignupViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currentState.countryList?.data?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        //create a view to show the country name
        if let countryData = currentState.countryList?.data {
            let index = countryData.index(countryData.startIndex , offsetBy: row)
            let countryName = countryData.values[index].country
//            let region = countryData.values[index].region

            let countryView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width - 30, height: 50))
            
            let nameLabel = UILabel(frame: CGRect(x: 35, y: 0, width: pickerView.bounds.width - 75, height: 50))

            nameLabel.font = UIFont.degularMedium(UIFont.Size.size_18)
            nameLabel.textAlignment = .center
            nameLabel.center.y = countryView.center.y
            nameLabel.text = countryName

            countryView.addSubview(nameLabel)

            return countryView
        }
        return UIView()
    }
}

extension SignupViewController {
    @objc func emailFieldEdited() {
        presenter?.checkForValidEmail(text: emailTextView.text)
    }
    
    @objc func passwordFieldEdited() {
        presenter?.checkForValidPassword(text: passwordTextView.text, isForLogin: isForLogin)
    }
}
