//
//  WikipediaHelper.swift
//  PediAR
//
//  Created by 宋 奎熹 on 2017/11/4.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

import UIKit

class WikipediaHelper: NSObject {

    static let shared: WikipediaHelper = WikipediaHelper()
    
    private override init() {
        
    }
    
    func getSummary(of title: String, completion: @escaping (_ model: WikiModel) -> Void) {
        let string = "https://en.wikipedia.org/api/rest_v1/page/summary/\(title)"
        if let url = URL(string: string.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) {
            let session = URLSession(configuration: .default)
            session.dataTask(with: url) { (data, _, err) in
                guard err == nil else { return }
                
                guard let data = data else { return }
                if let repo = try? JSONDecoder().decode(WikiModel.self, from: data) {
                    print(repo)
                } else {
                    print("JSON parse failed")
                }
            }.resume()
        }
    }
    
}
