//
//  WikipediaHelper.swift
//  PediAR
//
//  Created by 宋 奎熹 on 2017/11/4.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

import UIKit
import SwiftyJSON

class WikipediaHelper: NSObject {

    static let shared: WikipediaHelper = WikipediaHelper()
    
    private override init() {}
    
    func getSummary(of title: String, completion: @escaping (_ model: WikiModel?) -> Void) {
        let string = "https://en.wikipedia.org/api/rest_v1/page/summary/\(title)"
        if let url = URL(string: string.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) {
            let session = URLSession(configuration: .default)
            session.dataTask(with: url) { (data, _, err) in
                guard err == nil else {
                    completion(nil)
                    return
                }
                guard let data = data else {
                    completion(nil)
                    return
                }
                if let repo = try? JSONDecoder().decode(WikiModel.self, from: data) {
                    completion(repo)
                } else {
                    print("JSON parse failed")
                    completion(nil)
                }
            }.resume()
        }
    }
    
    func getURL(from pageId: String, completion: @escaping (_ url: String?) -> Void) {
        let urlStr = "https://en.wikipedia.org/w/api.php?action=query&prop=info&pageids=\(pageId)&inprop=url&format=json"
        if let url = URL(string: urlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) {
            let session = URLSession(configuration: .default)
            session.dataTask(with: url, completionHandler: {
                data, response, err in
                guard err == nil else {
                    completion(nil)
                    return
                }
                guard let data = data else {
                    completion(nil)
                    return
                }
                let realUrl = JSON(data: data)["query"]["pages"][pageId]["fullurl"].stringValue
                completion(realUrl)
            }).resume()
        }
    }
    
}
