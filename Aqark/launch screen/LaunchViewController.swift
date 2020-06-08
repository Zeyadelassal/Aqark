//
//  LaunchViewController.swift
//  Aqark
//
//  Created by Mostafa Samir on 5/6/20.
//  Copyright © 2020 ITI. All rights reserved.
//

import UIKit
import SwiftyGif
import ImageIO

class LaunchViewController: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    let logoGifImageView = UIImageView(gifImage: UIImage(gifName: "logoGif"), loopCount: 1)

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        print("  print  ")
        backgroundColor = UIColor(white: 246.0 / 255.0, alpha: 1)
        addSubview(logoGifImageView)
        logoGifImageView.frame = CGRect(x: frame.size.height / 2, y: frame.size.width  / 2, width: 150, height: 280.0)
    //    logoGifImageView.center = CGPoint(x: self.frame.size.width  / 2,
                                //     y: self.frame.size.height / 2)
//        logoGifImageView.translatesAutoresizingMaskIntoConstraints = false
//        logoGifImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        logoGifImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        logoGifImageView.widthAnchor.constraint(equalToConstant: 280).isActive = true
//        logoGifImageView.heightAnchor.constraint(equalToConstant: 108).isActive = true
    }
}

