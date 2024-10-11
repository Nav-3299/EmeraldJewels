//
//  EJJewelleryModel.swift
//  EmeraldJewels
//
//  Created by Navpreet Kaur on 10/10/24.
//

import Foundation
import Foundation

struct JewelleryResponse: Codable {
    let products: [JewelleryProduct]
}

struct JewelleryProduct: Codable, Identifiable  {
    let id: Int?
    let name: String?
    let description: String?
    let price: Double?
    let currency: String?
    let imageUrl: String?
}
