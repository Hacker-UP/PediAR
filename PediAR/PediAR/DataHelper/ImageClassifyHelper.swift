//
//  ImageClassifier.swift
//  PediAR
//
//  Created by 宋 奎熹 on 2017/11/4.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

import UIKit
import VisualRecognitionV3
import SwiftyJSON

class ImageClassifyHelper: NSObject {

    static let shared: ImageClassifyHelper = ImageClassifyHelper()
    
    private var visualRecognition: VisualRecognition
    
    private override init() {
        let version = Date().getIBMVersionString()  // use today's date for the most recent version
        visualRecognition = VisualRecognition(apiKey: kIBMVisualRecognitionKey, version: version)
    }
    
    func uploadImage(_ image: UIImage, completion: @escaping (_ url: String?) -> Void) {
        let imageData = UIImageJPEGRepresentation(image, 0.5)!
        print(imageData)
        completion(nil)
    }
    
    func classify(withUrl url: String, completion: @escaping ((_ resultTupleArray: [(name: String, score: Double)]) -> Void)) {
        let failure = { (error: Error) in print(error) }
        visualRecognition.classify(image: url, language: "en", failure: failure) { classifiedImages in
            completion((classifiedImages.images.first?.classifiers.first?.classes.map { ($0.classification, $0.score) })!)
        }
    }
    
    func getImage(with name: String, completion: @escaping ([String]) -> ()) {
        let urlstr = "http://139.198.190.108:8086/?word=\(name)"
        if let url = URL(string: urlstr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) {
            let session = URLSession(configuration: .default)
            session.dataTask(with: url) { (data, _, err) in
                guard let data = data else {
                    return
                }
                guard let res = String.init(data: data, encoding: String.Encoding.utf8) else {
                    return
                }
                let datas = res.split(separator: "\n").map(String.init)
                if datas.count > 0 {
                    completion(datas)
                }
            }.resume()
        }
    }
    
}
