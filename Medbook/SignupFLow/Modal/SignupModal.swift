//
//  SignupModal.swift
//  Medbook
//
//  Created by Kamal Negi on 02/10/23.
//

import Foundation

struct CountryList: Decodable {
    var data: [String:CountryDetail]?
}

struct CountryDetail: Decodable {
    var country: String?
    var region: String?
}
