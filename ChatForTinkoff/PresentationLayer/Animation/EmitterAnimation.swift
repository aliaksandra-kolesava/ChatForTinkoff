//
//  EmitterAnimation.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 25.11.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import Foundation
import UIKit

protocol EmitterAnimationProtocol {
    func gestureIsMade(currentView: UIView, sender: UILongPressGestureRecognizer)
}

class EmitterAnimation: EmitterAnimationProtocol {

    let emitterLayer = CAEmitterLayer()
    
    func gestureIsMade(currentView: UIView, sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: currentView) 
        if sender.state == .began {
            showEmitter(position: location)
            currentView.layer.addSublayer(emitterLayer)
        } else if sender.state == .changed {
            showEmitter(position: location)
        } else if sender.state == .ended {
            guard let layers = currentView.layer.sublayers else { return }
            for layer in layers {
                if let emitterLayer = layer as? CAEmitterLayer {
                    emitterLayer.removeFromSuperlayer()
                    emitterLayer.removeAllAnimations()
                }
            }
        }
    }
    
    lazy var emitterCell: CAEmitterCell = {
        
        let cell = CAEmitterCell()
        let imageFlame = UIImage(named: "Tinkoff")
        cell.contents = imageFlame?.cgImage
        cell.lifetime = 2.0
        cell.birthRate = 20.0
        cell.alphaSpeed = -0.4
        cell.scale = 0.06
        cell.scaleRange = 0.25
        cell.velocity = 100
        cell.velocityRange = 100
        cell.emissionRange = CGFloat.pi * 2
        cell.spin = 2
        
        return cell
    }()
    
    func showEmitter(position: CGPoint) {
        emitterLayer.emitterSize = CGSize(width: 20, height: 20)
        emitterLayer.emitterPosition = position
        emitterLayer.emitterShape = .point
        emitterLayer.renderMode = .additive
        emitterLayer.emitterCells = [emitterCell]
    }
    
}
