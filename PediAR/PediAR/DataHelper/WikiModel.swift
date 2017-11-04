//
//  WikiModel.swift
//  PediAR
//
//  Created by 宋 奎熹 on 2017/11/4.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

import Foundation

struct WikiModel: Codable {
    
    var title: String = ""
    var displaytitle: String = ""
    var pageid: Int = 0
    var extract: String = ""
    var extract_html: String = ""
    var thumbnail: WikiImage = WikiImage()
    var originalimage: WikiImage = WikiImage()
    var lang: String = ""
    var dir: String = ""
    var timestamp: String = ""
    var description: String = ""
    
    struct WikiImage: Codable {
        var source: String = ""
        var width: Int = 0
        var height: Int = 0
    }
}
