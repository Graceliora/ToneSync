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
    
    var tone = "Tone"
    @Published var color1: Color?
    @Published var color2: Color?
    @Published var color3: Color?
    @Published var color4: Color?
    @Published var color5: Color?
    
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
                    tone = "FL"
                } else if identifier1 == "Medium_tane: " && confidence1 >= confidence2 && confidence1 >= confidence3 {
                    classified = "Your skin tone is medium tane"
                    tone = "MT"
                } else if identifier1 == "Dark_deep: " && confidence1 >= confidence2 && confidence1 >= confidence3 {
                    classified = "Your skin tone is dark deep"
                    tone = "DD"
                } else if identifier2 == "Fair_light: " && confidence2 >= confidence1 && confidence2 >= confidence3 {
                    classified = "Your skin tone is fair light"
                    tone = "FL"
                } else if identifier2 == "Medium_tane: " && confidence2 >= confidence1 && confidence2 >= confidence3 {
                    classified = "Your skin tone is medium tane"
                    tone = "MT"
                } else if identifier2 == "Dark_deep: " && confidence2 >= confidence1 && confidence2 >= confidence3 {
                    classified = "Your skin tone is dark deep"
                    tone = "DD"
                } else if identifier3 == "Fair_light: " && confidence3 >= confidence1 && confidence3 >= confidence2 {
                    classified = "Your skin tone is fair light"
                    tone = "FL"
                } else if identifier3 == "Medium_tane: " && confidence3 >= confidence1 && confidence3 >= confidence2 {
                    classified = "Your skin tone is medium tane"
                    tone = "MT"
                } else if identifier3 == "Dark_deep: " && confidence3 >= confidence1 && confidence3 >= confidence2 {
                    classified = "Your skin tone is dark deep"
                    tone = "DD"
                } else {
                    classified = "Ya apa lagi ya"
                }
                
                recommendation()
                print(classified)
                
                print("Classification: \n" + identifier1 + confidence1 + identifier2 + confidence2 + identifier3 + confidence3)
            }
        }
    
    func recommendation() {
        print(classified)
        if classified == "Your skin tone is fair light" {
            color1 = .pink1
            color2 = .pink2
            color3 = .pink3
            color4 = .pink4
            color5 = .pink5
        } else if classified == "Your skin tone is medium tane" {
            color1 = .white
            color2 = .white
            color3 = .white
            color4 = .white
            color5 = .white
        } else if classified == "Your skin tone is dark deep" {
            color1 = .black
            color2 = .black
            color3 = .black
            color4 = .black
            color5 = .black
        } else {
            color1 = .blue
            color2 = .blue
            color3 = .blue
            color4 = .blue
            color5 = .blue
            
        }
    }
}
