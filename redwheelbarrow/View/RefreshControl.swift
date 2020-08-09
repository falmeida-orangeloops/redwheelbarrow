//
//  RefreshControl.swift
//  mynotesapp
//
//  Created by Facundo Almeida on 7/9/20.
//  Copyright © 2020 Facundo Almeida. All rights reserved.
//

import UIKit
import JHPullToRefreshKit

class RefreshControl: JHRefreshControl {
    var imageView: UIImageView?
    
    override class func height() -> CGFloat {
        return 40
    }
    
    override class func animationDuration() -> TimeInterval {
        return 1
    }
    
    override func setup() {
        
        var animationImages = [UIImage]()
        
        for i in 0...12 {
            if let frame = UIImage(named: String(format: "frame%d.png", i)) {
                animationImages.append(frame)
            }
        }
        
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        
        guard let imageView = self.imageView else {
            return
        }
        
        imageView.contentMode = .center
        imageView.animationDuration = RefreshControl.animationDuration()
        imageView.animationImages = animationImages
        imageView.startAnimating()
        
        self.addSubview(imageView)
    }
    
    override func handleScrolling(onAnimationView animationView: UIView!, withPullDistance pullDistance: CGFloat, pullRatio: CGFloat, pullVelocity: CGFloat) {
    }
    
    override func setupRefreshControl(forAnimationView animationView: UIView!) {
    }
    
    override func animationCycle(forAnimationView animationView: UIView!) {
    }
}
