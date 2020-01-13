//
//  StackViewExtension.swift
//  WowWeather
//
//  Created by asd dsa on 11/6/19.
//  Copyright © 2019 asd dsa. All rights reserved.
//

import UIKit

extension UIStackView {
    
    func addBackgroundColor(color: UIColor) {
        let backgroundView = UIView(frame: bounds)
        backgroundView.backgroundColor = color
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(backgroundView, at: 0)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
    }
    
}
