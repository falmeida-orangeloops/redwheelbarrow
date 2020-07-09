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
        var frames = [UIImage]()
        
        for i in 1...12 {
            guard let frame = UIImage(named: String(format: "frame%d.png", i)) else {
                continue
            }
            
            frames.append(frame)
        }
        
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frames[0].size.width, height: frames[0].size.height))
        
        guard let imageView = self.imageView else {
            return
        }
        
        imageView.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        imageView.animationDuration = 1
        imageView.animationImages = frames
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
