//
//  DataItemsView.swift
//  PediAR
//
//  Created by Harry Twan on 04/11/2017.
//  Copyright © 2017 宋 奎熹. All rights reserved.
//

import UIKit

class DataItemView: UIView {
    
    fileprivate var collectionView: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialDatas()
        initialViews()
        initialLayouts()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func initialDatas() {
        
    }
    
    private func initialViews() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(white: 0, alpha: 0.48)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "\(UICollectionViewCell.self)")
        collectionView.register(UINib.init(nibName: "DataItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "\(DataItemCollectionViewCell.self)")

        addSubview(collectionView)
    }
    
    private func initialLayouts() {
        collectionView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(self)
        }
    }
}

// MARK: - UICollectionDelegate
extension DataItemView: UICollectionViewDelegate {}

// MARK: - UICollectionDataSource
extension DataItemView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(DataItemCollectionViewCell.self)", for: indexPath)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension DataItemView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}
