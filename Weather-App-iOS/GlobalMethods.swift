//
//  GlobalMethods.swift
//  Weather-App-iOS
//
//  Created by iPHTech on 18/07/23.
//

import Foundation
import UIKit

func craeteGredientColor(rect: CGRect, topColor: UIColor, bottomColor: UIColor) -> CAGradientLayer {
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [topColor.cgColor,bottomColor.cgColor]
    gradientLayer.locations = [0.0, 1.0]
    // gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
    gradientLayer.frame = rect
    return gradientLayer
}
