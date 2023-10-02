//
//  AppLandingScreen.swift
//  Medbook
//
//  Created by Kamal Negi on 01/10/23.
//

import UIKit

class AppLandingScreen: UIViewController {

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = "MedBook"
            titleLabel.font = UIFont.degularBold(UIFont.Size.size_32)
            titleLabel.textColor = .black
        }
    }
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.image = UIImage(named: "landing")
        }
    }
    
    @IBOutlet weak var signupButton: UIButton! {
        didSet {
            signupButton.setTitle("Signup", for: .normal)
            signupButton.layer.cornerRadius = 12
            signupButton.setTitleColor(.black, for: .normal)
            signupButton.layer.borderColor = UIColor.black.cgColor
            signupButton.layer.borderWidth = 1
            signupButton.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
            signupButton.titleLabel?.font = UIFont.degularMedium(UIFont.Size.size_22)
            signupButton.backgroundColor = UIColor.colorFromHexString(hexString: "#FFFFFF")
        }
    }
    
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            loginButton.setTitle("Login", for: .normal)
            loginButton.layer.cornerRadius = 12
            loginButton.setTitleColor(.black, for: .normal)
            loginButton.layer.borderColor = UIColor.black.cgColor
            loginButton.layer.borderWidth = 1
            loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
            loginButton.titleLabel?.font = UIFont.degularMedium(UIFont.Size.size_22)
            loginButton.backgroundColor = UIColor.colorFromHexString(hexString: "#FFFFFF")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        self.view.backgroundColor = UIColor.colorFromHexString(hexString: "#EEEEEE")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @objc func signupButtonTapped() {
        let storyBoard = UIStoryboard(name: "SignupViewController", bundle: nil)
        let viewController = storyBoard.instantiateViewController(identifier: "SignupViewController") as SignupViewController
        viewController.isForLogin = false
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    @objc func loginButtonTapped() {
        let storyBoard = UIStoryboard(name: "SignupViewController", bundle: nil)
        let viewController = storyBoard.instantiateViewController(identifier: "SignupViewController") as SignupViewController
        viewController.isForLogin = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

