//
//  UIViewControllerExtension.swift
//  Medbook
//
//  Created by Kamal Negi on 02/10/23.
//

import Foundation
import UIKit

extension UIViewController {
    func setupNavigationBar() {
        //set navigation bar for all view controllers
        self.navigationController?.navigationBar.barStyle = .black
        let backItem = UIBarButtonItem()
        backItem.title = ""
        backItem.tintColor = .black
        navigationItem.backBarButtonItem = backItem
        self.navigationController?.navigationBar.barStyle = .default
    }
}
