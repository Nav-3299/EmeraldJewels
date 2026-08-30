//
//  EJJewlleryViewModel.swift
//  EmeraldJewels
//
//  Created by Navpreet Kaur on 10/10/24.
//

import Foundation

protocol JewelleryRepository {
    func fetchProducts() throws -> [JewelleryProduct]
}

struct LocalJewelleryRepository: JewelleryRepository {
    func fetchProducts() throws -> [JewelleryProduct] {
        try JSONDecoder().decode([JewelleryProduct].self, from: EJjewelleryProducts)
    }
}


@MainActor
final class JewelleryViewModel: ObservableObject {
    @Published private(set) var jewelleryProducts: [JewelleryProduct] = []
    @Published var errorMessage: String?

    private let repository: any JewelleryRepository

    init(repository: any JewelleryRepository = LocalJewelleryRepository()) {
        self.repository = repository
        loadJewelryProducts()
    }

    // Function to load and decode the JSON
    func loadJewelryProducts() {
        do {
            jewelleryProducts = try repository.fetchProducts()
            errorMessage = nil
        } catch {
            jewelleryProducts = []
            errorMessage = "Unable to load the jewellery catalogue."
        }
    }
}
