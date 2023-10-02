//
//  UIFontExtension.swift
//  Medbook
//
//  Created by Kamal Negi on 02/10/23.
//

import Foundation
import UIKit

extension UIFont {
    class func degularBold(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Degular-Bold", size: size)!
    }
    
    class func degularSemibold(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Degular-Semibold", size: size)!
    }
    
    class func degularRegular(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Degular-Regular", size: size)!
    }
    
    class func degularMedium(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Degular-Medium", size: size)!
    }
    
    struct Size {
        static let size_22: CGFloat = 22
        static let size_32: CGFloat = 32
        static let size_18: CGFloat = 18
        static let size_12: CGFloat = 12
    }
}
