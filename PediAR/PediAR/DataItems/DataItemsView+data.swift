//
//  DataItemsView+data.swift
//  PediAR
//
//  Created by Harry Twan on 05/11/2017.
//  Copyright © 2017 宋 奎熹. All rights reserved.
//

import UIKit

// MARK: Data Creater
extension DataItemView {
    
    public func getData(array: [String]) {
        var data: [DataItemCollectionViewCellModel] = []
        for url in array {
            let item = DataItemCollectionViewCellModel()
            item.imageUrl = url
            data.append(item)
        }
        self.viewModels = data
    }
    
    public func getData(by name: String) {
        if name.components(separatedBy: "mouse").count > 1 {
            self.viewModels = DataItemView.getMouseData()
        }
        else if name.components(separatedBy: "keyboard").count > 1 {
            self.viewModels = DataItemView.getKeyboardData()
        }
        else if name.components(separatedBy: "computer").count > 1 {
            self.viewModels = DataItemView.getPCData()
        }
        else {
            self.viewModels = []
        }
    }
    
    static func getMouseData() -> [DataItemCollectionViewCellModel] {
        var data: [DataItemCollectionViewCellModel] = []
        let urlArray = [
            "https://p3.pstatp.com/origin/18dc00067637faa4c7d9",
            "https://p3.pstatp.com/origin/18dc0006716ffa2952fe",
            "https://p3.pstatp.com/origin/199d000138a4f8ffd497",
            "https://p3.pstatp.com/origin/18dd0005f1e1733ae490",
            "https://p3.pstatp.com/origin/187d0005d9a624585720",
        ]
        for url in urlArray {
            let item = DataItemCollectionViewCellModel()
            item.imageUrl = url
            data.append(item)
        }
        return data
    }
    
    static func getPCData() -> [DataItemCollectionViewCellModel] {
        var data: [DataItemCollectionViewCellModel] = []
        let urlArray = [
            "https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=350709295,1448582684&fm=27&gp=0.jpg",
            "http://www.taopic.com/uploads/allimg/140328/235041-14032Q2121752.jpg",
            "http://www.taopic.com/uploads/allimg/140328/235041-14032Q0553729.jpg",
        ]
        for url in urlArray {
            let item = DataItemCollectionViewCellModel()
            item.imageUrl = url
            data.append(item)
        }
        return data
    }
    
    static func getKeyboardData() -> [DataItemCollectionViewCellModel] {
        var data: [DataItemCollectionViewCellModel] = []
        let urlArray = [
            "http://mpic.tiankong.com/873/00d/87300d7720e77f031a99c440d1537208/640.jpg",
            "http://mpic.tiankong.com/11a/993/11a993d6602229351ed422f97a5f93a3/640.jpg",
            "http://mpic.tiankong.com/be6/a6c/be6a6c20add0de936d78096c0d79e5d0/640.jpg",
            "http://mpic.tiankong.com/cf0/e20/cf0e207e014ca806789d27b55441ab21/640.jpg",
            "http://mpic.tiankong.com/7d2/18c/7d218cc5cc6012e1094456ebad38d02a/640.jpg",
        ]
        for url in urlArray {
            let item = DataItemCollectionViewCellModel()
            item.imageUrl = url
            data.append(item)
        }
        return data
    }
}
