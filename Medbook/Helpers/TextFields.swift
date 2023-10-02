//
//  TextFields.swift
//  Medbook
//
//  Created by Kamal Negi on 02/10/23.
//

import Foundation
import UIKit

enum TextFieldsStyle {
    case email
    case password
}

enum TextFieldsStatus: Equatable {
    case valid
    case invalid(String)
    case none
}

class TextFields: UITextField {
    //custome text filed class
    var type: TextFieldsStyle = .email {
        didSet {
            setup()
        }
    }
    
    var status: TextFieldsStatus = .valid {
        didSet {
            checkStatus()
        }
    }
    
    let shapeLayer = CAShapeLayer()
    
    //padding
    let padding =  UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 30)
    let placeholderPadding = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 30)
    var contentSize: CGSize = CGSize(width: 300.0, height: 45.0)
    var kContentOffset: CGFloat = 40.0
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.degularRegular(UIFont.Size.size_12)
        label.numberOfLines = 0
        label.text = ""
        label.textColor = #colorLiteral(red: 1, green: 0.1098039216, blue: 0, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return label
    }()
    
    let rightButton: UIButton = {
        //eye button for the password
        let button = UIButton()
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(rightButtonTapAction), for: .touchUpInside)
        return button
    }()
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        //placeholder
        return bounds.inset(by: placeholderPadding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override var intrinsicContentSize: CGSize {
        return super.intrinsicContentSize
    }
    
    
    //MARK: - INIT
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.borderStyle = .none
        self.keyboardType = .default
        
        setup()
        checkStatus()
        addBottomBorder()
        prepareTextAlignment()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.borderStyle = .none
        self.keyboardType = .default
        
        setup()
        checkStatus()
        addBottomBorder()
        prepareTextAlignment()
    }
    
    func prepareTextAlignment() {
      textAlignment = .rightToLeft == UIApplication.shared.userInterfaceLayoutDirection ? .right : .left
    }
    
    private func setup() {
        switch type {
        case .email:
            setupEmailTextfield()
        case .password:
            setupPasswordTextfield()
        }
    }
    
    private func setupEmailTextfield() {
        self.keyboardType = .emailAddress
    }
    
    private func setupPasswordTextfield() {
        self.isSecureTextEntry = true
        setupStatusImageView()
    }
    
    private func checkStatus() {
        switch status {
        case .valid:
            statusValid()
        case .invalid(let message):
            statusInvalid(message: message)
        case .none:
            break
        }
    }
    
    private func setupStatusImageView() {
        //eye image based on the button is selected or not
        rightButton.frame = CGRect(x: -10, y: 0, width: 22, height: 22)
        rightButton.contentMode = .scaleAspectFit
        rightButton.setImage(UIImage(named: "password_show_icon"), for: .selected)
        rightButton.setImage(UIImage(named: "password_hide_icon"), for: .normal)
        self.rightView = rightButton
        self.rightViewMode = .always
    }
    
    private func statusValid() {
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        if type == .email {
            self.textColor = UIColor.gray
        }
        messageLabel.removeFromSuperview()
    }
    
    private func statusInvalid(message: String) {
        shapeLayer.strokeColor = #colorLiteral(red: 1, green: 0.1098039216, blue: 0, alpha: 1)
        if type == .email {
            self.textColor = #colorLiteral(red: 1, green: 0.1098039216, blue: 0, alpha: 1)
        }
        setupMessageLabel(withMessage: message)
    }
    
    private func setupMessageLabel(withMessage messageString: String) {
        self.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: self.frame.height + 2),
            messageLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            messageLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0)
        ])
        messageLabel.text = messageString
    }
    
    private func addBottomBorder() {
        
        //add the bottom border
        let screenSize = UIScreen.main.bounds.width - 45
        self.setWidth(width: screenSize)
        
        //design the path
        let path = UIBezierPath()
        path.move(to: CGPoint(x: -1, y: self.frame.size.height))
        path.addLine(to: CGPoint(x: screenSize + 1, y: self.frame.size.height))
        
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = 1.0
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        self.layer.addSublayer(shapeLayer)
    }
    
    @objc func rightButtonTapAction(sender: UIButton) {
        rightButton.isSelected = !sender.isSelected
        rightButton.isSelected == true ? showSecureText() : hideSecureText()
    }
    
    private func showSecureText() {
        self.isSecureTextEntry = false
    }
    
    private func hideSecureText() {
        self.isSecureTextEntry = true
    }
    
    func setWidth(width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func setHeight(height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}

