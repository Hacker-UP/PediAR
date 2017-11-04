//
//  NLPUnderstandingHelper.swift
//  PediAR
//
//  Created by 宋 奎熹 on 2017/11/4.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

import UIKit
import NaturalLanguageUnderstandingV1

class NLPUnderstandingHelper: NSObject {

    static let shared: NLPUnderstandingHelper = NLPUnderstandingHelper()
    
    private var naturalLanguageUnderstanding: NaturalLanguageUnderstanding
    
    private let maximumResultNumber = 5
    
    private override init() {
        let version = Date().getIBMVersionString()
        naturalLanguageUnderstanding = NaturalLanguageUnderstanding(username: kIBMNLPUnderstandingUsername,
                                                                        password: kIBMNLPUnderstandingPassword,
                                                                        version: version)
    }
    
    func analyze(text: String) -> Void {
        let features = Features(concepts: ConceptsOptions.init(limit: maximumResultNumber),
                                keywords: KeywordsOptions.init(limit: maximumResultNumber))
        let parameters = Parameters(features: features, text: text)
        
        let failure = { (error: Error) in print(error) }
        naturalLanguageUnderstanding.analyze(parameters: parameters, failure: failure, success: {
            results in
            print (results)
        })
    }
    
}
