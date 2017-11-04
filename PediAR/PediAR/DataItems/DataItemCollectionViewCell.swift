//
//  DataItemCollectionViewCell.swift
//  PediAR
//
//  Created by Harry Twan on 04/11/2017.
//  Copyright © 2017 宋 奎熹. All rights reserved.
//

import UIKit
import Kingfisher

class DataItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bakView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    public var viewModel = DataItemCollectionViewCellModel() {
        didSet {
            if let url = URL(string: viewModel.imageUrl) {
                imageView.kf.setImage(with: url)
            }
            bakView.backgroundColor = viewModel.backgroundColor
        }
    }
    
    public var clickAction: () -> () = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialViews()
    }

    fileprivate func initialViews() {
        backgroundColor = viewModel.backgroundColor
        
        bakView.layer.masksToBounds = true
        bakView.layer.cornerRadius = 5
        bakView.layer.shadowColor = UIColor.black.cgColor
        bakView.layer.shadowOpacity = 0.8
        bakView.layer.shadowRadius = 5
        bakView.layer.shadowOffset = CGSize(width: 2, height: 2)
        
        imageView.isUserInteractionEnabled = true

        let tapGestureRec = UITapGestureRecognizer.init(target: self, action: #selector(clickImage))
        imageView.addGestureRecognizer(tapGestureRec)
    }

    @objc func clickImage() {
        print("click")
        clickAction()
    }
}

@objcMembers
class DataItemCollectionViewCellModel: NSObject {
    var backgroundColor = UIColor.clear
    var imageUrl: String = ""
}
