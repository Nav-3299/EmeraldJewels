//
//  EJJewelleryModel.swift
//  EmeraldJewels
//
//  Created by Navpreet Kaur on 10/10/24.
//

import Foundation

struct JewelleryProduct: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    let name: String
    let description: String
    let price: Double
    let currency: String
    let imageUrl: String

    var formattedPrice: String {
        "\(currency) \(price.formatted(.number.precision(.fractionLength(2))))"
    }
}
