//
//  LaunchViewController.swift
//  PediAR
//
//  Created by Harry Twan on 04/11/2017.
//  Copyright © 2017 宋 奎熹. All rights reserved.
//

import UIKit
import SnapKit

class LaunchViewController: UIViewController {
    
    let kAnimationDuration = 0.3
    
    fileprivate let flickIconButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "flick-button"), for: .normal)
//        button.addTarget(self, action: #selector(toVR), for: .touchUpInside)
        return button
    }()
    
    fileprivate let jumpIconButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "jump-button"), for: .normal)
        button.addTarget(self, action: #selector(toVR), for: .touchUpInside)
        return button
    }()
    
    @IBOutlet weak var instructionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        initialViews()
        initialLayouts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: kAnimationDuration) {
            self.flickIconButton.alpha = 0
        }
        UIView.animate(withDuration: kAnimationDuration, delay: kAnimationDuration, options: .curveEaseInOut, animations: {
            self.instructionLabel.alpha = 1
        }, completion: nil)
    }
    
    private func initialViews() {
        view.addSubview(jumpIconButton)
        view.addSubview(flickIconButton)
    }

    private func initialLayouts() {
        flickIconButton.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
        
        jumpIconButton.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
    }
}

// MARK: - entrance
extension LaunchViewController {
    @objc fileprivate func toVR() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewController")
        present(vc, animated: true) {}
    }
}
