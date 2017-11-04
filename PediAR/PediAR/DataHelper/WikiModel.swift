//
//  WikiModel.swift
//  PediAR
//
//  Created by 宋 奎熹 on 2017/11/4.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

import Foundation

struct WikiModel: Codable {
    
    var title: String
    var displaytitle: String
    var pageid: Int
    var extract: String
    var extract_html: String
    var thumbnail: WikiImage
    var originalimage: WikiImage
    var lang: String
    var dir: String
    var timestamp: String
    var description: String
    
    struct WikiImage: Codable {
        var source: String
        var width: Int
        var height: Int
    }
    
}
