//
//  ViewControllerHelper.swift
//  PediAR
//
//  Created by Harry Twan on 04/11/2017.
//  Copyright © 2017 宋 奎熹. All rights reserved.
//

import UIKit

// MARK: - Target
extension ViewController {
    @objc public func controlMenu() {
        if menuIsOpen {
            UIView.animate(withDuration: 0.4) {
                self.dataItems.transform = CGAffineTransform(translationX: 0, y: 120)
                self.switchButton.transform = CGAffineTransform(translationX: 0, y: 100).rotated(by: CGFloat(Double.pi))
                self.tagListView.transform = CGAffineTransform(translationX: 0, y: 220)
            }
            menuIsOpen = false
        } else {
            UIView.animate(withDuration: 0.4) {
                self.dataItems.transform = .identity
                self.switchButton.transform = .identity
                self.tagListView.transform = .identity
            }
            menuIsOpen = true
        }
    }
}
