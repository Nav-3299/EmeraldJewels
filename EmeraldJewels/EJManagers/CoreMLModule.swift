//
//  CoreMLModule.swift
//  EmeraldJewels
//
//  Created by Navpreet Kaur on 08/10/24.
//

import CoreML
import Vision
import UIKit

func classifyOutfit(image: UIImage, completion: @escaping (String?) -> Void) {
    guard let model = try? VNCoreMLModel(for: ClothesClassifier().model) else {
        completion(nil)
        return
    }
    
    let request = VNCoreMLRequest(model: model) { request, error in
        guard let results = request.results as? [VNClassificationObservation],
              let topResult = results.first else {
            completion(nil)
            return
        }
        completion(topResult.identifier)  // Return outfit classification result
    }
    
    guard let ciImage = CIImage(image: image) else {
        completion(nil)
        return
    }
    
    let handler = VNImageRequestHandler(ciImage: ciImage)
    DispatchQueue.global().async {
        do {
            try handler.perform([request])
        } catch {
            completion(nil)
        }
    }
}

func recommendJewellery(for outfit: String) -> [String] {
    switch outfit {
    case "shirt":
        return ["Simple Necklace", "Stud Earrings"]
    case "dress":
        return ["Gold Bracelet", "Diamond Necklace"]
    case "longsleeves":
        return ["Silver Earrings", "Pearl Necklace"]
    default:
        return ["Jewelry not available"]
    }
}





