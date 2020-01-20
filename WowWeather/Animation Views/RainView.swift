//
//  RainView.swift
//  WowWeather
//
//  Created by asd dsa on 1/14/20.
//  Copyright © 2020 asd dsa. All rights reserved.
//

import UIKit
import QuartzCore

class RainView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let emitter = layer as! CAEmitterLayer
        emitter.emitterPosition = CGPoint(x: bounds.size.width / 2, y: 0)
        emitter.emitterSize = bounds.size
        emitter.emitterShape = .rectangle
        
        let emitterCell = CAEmitterCell()
        emitterCell.contents = UIImage(named: "raindrop.png")!.cgImage
        emitterCell.birthRate = 500
        emitterCell.lifetime = 5.5
        emitterCell.color = UIColor.white.cgColor
        emitterCell.redRange = 0.0
        emitterCell.blueRange = 0.1
        emitterCell.greenRange = 0.0
        emitterCell.velocity = 1
        emitterCell.velocityRange = 30
        emitterCell.emissionRange = CGFloat(Double.pi/2)
        emitterCell.emissionLongitude = CGFloat(-Double.pi)
        emitterCell.yAcceleration = 70
        emitterCell.xAcceleration = 15
        emitterCell.scale = 0.01
        emitterCell.scaleRange = 0.00
        emitterCell.scaleSpeed = 0.04
        emitterCell.alphaRange = 0.5
        emitterCell.alphaSpeed = -0.15
        
        emitter.emitterCells = [emitterCell]
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class var layerClass: AnyClass {
        return CAEmitterLayer.self
    }
}
