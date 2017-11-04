//
//  ImageClassifier.swift
//  PediAR
//
//  Created by 宋 奎熹 on 2017/11/4.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

import UIKit
import VisualRecognitionV3


class ImageClassifyHelper: NSObject {

    static let shared: ImageClassifyHelper = ImageClassifyHelper()
    
    private var visualRecognition: VisualRecognition
    
    private override init() {
        let version = Date().getIBMVersionString()  // use today's date for the most recent version
        visualRecognition = VisualRecognition(apiKey: kIBMVisualRecognitionKey, version: version)
    }
    
    func uploadImage(_ image: UIImage, completion: @escaping (_ url: String?) -> Void) {
        print(UIImageJPEGRepresentation(image, 0.5)!)
        let str = (UIImageJPEGRepresentation(image, 0.5)!).base64EncodedString().addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)
//        let str = String(data: imageData, encoding: String.Encoding.utf8)
        
        URL(string: "139.198.190.108:8087/?file=\(str)")
        if let url = URL(string: "http://139.198.190.108:8087/?file=\(str)") {
//            print(url)
            let session = URLSession(configuration: .default)
            session.dataTask(with: url, completionHandler: {
                data, response, err in
                print(response)
                guard err == nil else {
                    return
                }
                guard let data = data else {
                    completion(nil)
                    return
                }
                completion(nil)
            }).resume()
        }
    }
    
    func classify(withUrl url: String, completion: @escaping ((_ resultTupleArray: [(name: String, score: Double)]) -> Void)) {
        let failure = { (error: Error) in print(error) }
        visualRecognition.classify(image: url, language: "en", failure: failure) { classifiedImages in
            completion((classifiedImages.images.first?.classifiers.first?.classes.map { ($0.classification, $0.score) })!)
        }
    }
    
}
