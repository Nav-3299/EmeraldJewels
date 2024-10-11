//
//  EJJewlleryViewModel.swift
//  EmeraldJewels
//
//  Created by Navpreet Kaur on 10/10/24.
//

import Foundation


class JewelleryViewModel: ObservableObject {
    // Published array of jewellery products to be observed by the view
    @Published var jewelleryProducts: [JewelleryProduct] = []

    // Initializer to load data when the view model is created
    init() {
        loadJewelryProducts()
    }

    // Function to load and decode the JSON
    func loadJewelryProducts() {
        let decoder = JSONDecoder()
        do {
            // Decode the JSON into the jewelryProducts array
            
                // Decode the JSON into the jewelryProducts array
                           let decodedData = try decoder.decode([JewelleryProduct].self, from: EJjewelleryProducts)
                           DispatchQueue.main.async {
                               self.jewelleryProducts = decodedData
                           }
            
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
        }
    }
}
