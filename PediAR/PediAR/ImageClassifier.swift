//
//  ImageClassifier.swift
//  PediAR
//
//  Created by 宋 奎熹 on 2017/11/4.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

import UIKit
import VisualRecognitionV3

class ImageClassifier: NSObject {

    static let shared: ImageClassifier = ImageClassifier()
    
    private var visualRecognition: VisualRecognition
    
    private override init() {
        let apiKey = kIBMKey
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let version = dateFormatter.string(from: Date()) // use today's date for the most recent version
        visualRecognition = VisualRecognition(apiKey: apiKey, version: version)
    }
    
    func classifyImage(with url: String, completion: @escaping ((_ resultTupleArray: [(name: String, score: Double)]) -> Void)) {
        let failure = { (error: Error) in print(error) }
        visualRecognition.classify(image: url, language: "en", failure: failure) { classifiedImages in
            completion((classifiedImages.images.first?.classifiers.first?.classes.map { ($0.classification, $0.score) })!)
        }
    }
    
}
