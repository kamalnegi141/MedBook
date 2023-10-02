//
//  HomeViewController.swift
//  Medbook
//
//  Created by Kamal Negi on 01/10/23.
//

import UIKit
import Toaster

class HomeViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.image = UIImage(named: "book")
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = "MedBook"
            titleLabel.textColor = .black
            titleLabel.font = UIFont.degularBold(UIFont.Size.size_32)
        }
    }
    
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.text = "Which Topic interests you today?"
            descriptionLabel.textColor = .black
            descriptionLabel.font = UIFont.degularSemibold(UIFont.Size.size_18)
        }
    }
    
    @IBOutlet weak var logoutButton: UIButton! {
        didSet {
            logoutButton.setTitle("Logout", for: .normal)
            logoutButton.setTitleColor(.red, for: .normal)
            logoutButton.layer.borderWidth = 0
            logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
            logoutButton.titleLabel?.font = UIFont.degularSemibold(UIFont.Size.size_22)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        self.view.backgroundColor = UIColor.colorFromHexString(hexString: "#FAFAFA")
    }

    @objc func logoutButtonTapped() {
        showToast()
        let window = SceneDelegate.window
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
        let viewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "AppLandingScreen")
        let navigationController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func showToast() {
        let toast: Toast = Toast(text: "Logout Successfully")
        toast.show()
    }
}
