//
//  ViewModel.swift
//  ToneSync
//
//  Created by Gracella Noveliora on 20/05/24.
//

import Foundation
import SwiftUI
import Vision

class ViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var result = "Select the 'camera' button"
    @Published var classified = "Classify"

    
    func classifyingImage(uiImage: UIImage) {
        print("masuk pak eko")
        print(uiImage)
        guard let ciImage = CIImage(image: uiImage) else {
            return
        }
        let handler = VNImageRequestHandler(ciImage: ciImage)
        let request = VNClassifyImageRequest{request, error in
            if let result = request.results as? [VNClassificationObservation] {
                print("classification \(result.first!.identifier) confidence \(result.first!.confidence)")
            }
        }
        do {
            try handler.perform([request])
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
        // 1. Set Up Model
        lazy var classificationRequest: VNCoreMLRequest = {
    
            do {
                let model = try VNCoreMLModel(for: SkinToneClassifier().model)
    
                let request = VNCoreMLRequest(model: model, completionHandler: { [self] request, error in self.processClassifications(for: request, error: error)
                })
    
                request.imageCropAndScaleOption = .centerCrop
                return request
    
            } catch {
                fatalError("Failed to load Vision ML Model: \(error)")
            }
    
        }()
    
        // 2. Perform Request
        func updateClassifications(for image: UIImage) {
            print("Classifying...")
    
            // convert UIImage to CIImage so it can be processed
            let ciImage = CIImage(image: image)!
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: .up)
    
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                print("Failed to perform classification. \n\(error.localizedDescription)")
            }
        }
    
        // 3. Update Interface with Results from Classification
        func processClassifications(for request: VNRequest, error: Error?) {
        
            let classifications = request.results as! [VNClassificationObservation]
    
            if classifications.isEmpty {
                result = "Nothing recognized."
            } else {
                let identifier1 = classifications[0].identifier + ": "
                let confidence1 = String(classifications[0].confidence) + "\n"
    
                let identifier2 = classifications[1].identifier + ": "
                let confidence2 = String(classifications[1].confidence) + "\n"
    
                let identifier3 = classifications[2].identifier + ": "
                let confidence3 = String(classifications[2].confidence) + "\n"
    
                if identifier1 == "Fair_light: " && confidence1 >= confidence2 && confidence1 >= confidence3 {
                    classified = "Fair Light"
                } else if identifier1 == "Medium_tane: " && confidence1 >= confidence2 && confidence1 >= confidence3 {
                    classified = "Medium Tane"
                } else if identifier1 == "Dark_deep: " && confidence1 >= confidence2 && confidence1 >= confidence3 {
                    classified = "Dark Deep"
                } else if identifier2 == "Fair_light: " && confidence2 >= confidence1 && confidence2 >= confidence3 {
                    classified = "Fair Light"
                } else if identifier2 == "Medium_tane: " && confidence2 >= confidence1 && confidence2 >= confidence3 {
                    classified = "Medium Tane"
                } else if identifier2 == "Dark_deep: " && confidence2 >= confidence1 && confidence2 >= confidence3 {
                    classified = "Dark Deep"
                } else if identifier3 == "Fair_light: " && confidence3 >= confidence1 && confidence3 >= confidence2 {
                    classified = "Fair Light"
                } else if identifier3 == "Medium_tane: " && confidence3 >= confidence1 && confidence3 >= confidence2 {
                    classified = "Medium Tane"
                } else if identifier3 == "Dark_deep: " && confidence3 >= confidence1 && confidence3 >= confidence2 {
                    classified = "Dark Deep"
                } else {
                    classified = "Ya apa lagi ya"
                }
                
                result = "Classification: \n" + identifier1 + confidence1 + identifier2 + confidence2 + identifier3 + confidence3
            }
            
        }
}
