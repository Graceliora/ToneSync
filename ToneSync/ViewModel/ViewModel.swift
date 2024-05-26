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
    @Published var classified = "Analyze"
    
    @Published var color1: Color?
    @Published var color2: Color?
    @Published var color3: Color?
    @Published var color4: Color?
    @Published var color5: Color?
    
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
    
        func updateClassifications(for image: UIImage) {
            print("Classifying...")
    
            let ciImage = CIImage(image: image)!
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: .up)
    
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                print("Failed to perform classification. \n\(error.localizedDescription)")
            }
        }
    
        func processClassifications(for request: VNRequest, error: Error?) {
        
            let classifications = request.results as! [VNClassificationObservation]
    
            if classifications.isEmpty {
                print("Nothing recognized.")
            } else {
                let identifier1 = classifications[0].identifier + ": "
                let confidence1 = String(classifications[0].confidence) + "\n"
    
                let identifier2 = classifications[1].identifier + ": "
                let confidence2 = String(classifications[1].confidence) + "\n"
    
                let identifier3 = classifications[2].identifier + ": "
                let confidence3 = String(classifications[2].confidence) + "\n"
    
                if identifier1 == "Fair_light: " && confidence1 >= confidence2 && confidence1 >= confidence3 {
                    classified = "Your skin tone is fair light"
                } else if identifier1 == "Medium_tane: " && confidence1 >= confidence2 && confidence1 >= confidence3 {
                    classified = "Your skin tone is medium tane"
                } else if identifier1 == "Dark_deep: " && confidence1 >= confidence2 && confidence1 >= confidence3 {
                    classified = "Your skin tone is dark deep"
                } else if identifier2 == "Fair_light: " && confidence2 >= confidence1 && confidence2 >= confidence3 {
                    classified = "Your skin tone is fair light"
                } else if identifier2 == "Medium_tane: " && confidence2 >= confidence1 && confidence2 >= confidence3 {
                    classified = "Your skin tone is medium tane"
                } else if identifier2 == "Dark_deep: " && confidence2 >= confidence1 && confidence2 >= confidence3 {
                    classified = "Your skin tone is dark deep"
                } else if identifier3 == "Fair_light: " && confidence3 >= confidence1 && confidence3 >= confidence2 {
                    classified = "Your skin tone is fair light"
                } else if identifier3 == "Medium_tane: " && confidence3 >= confidence1 && confidence3 >= confidence2 {
                    classified = "Your skin tone is medium tane"
                } else if identifier3 == "Dark_deep: " && confidence3 >= confidence1 && confidence3 >= confidence2 {
                    classified = "Your skin tone is dark deep"
                } else {
                    
                }
                
                recommendation()
                
                print("Classification: \n" + identifier1 + confidence1 + identifier2 + confidence2 + identifier3 + confidence3)
            }
        }
    
    func recommendation() {
        print(classified)
        if classified == "Your skin tone is fair light" {
            color1 = .fl1
            color2 = .fl2
            color3 = .fl3
            color4 = .fl4
            color5 = .fl5
        } else if classified == "Your skin tone is medium tane" {
            color1 = .mt1
            color2 = .mt2
            color3 = .mt3
            color4 = .mt4
            color5 = .mt5
        } else if classified == "Your skin tone is dark deep" {
            color1 = .dd1
            color2 = .dd2
            color3 = .dd3
            color4 = .dd4
            color5 = .dd5
        } else {
        }
    }
}
