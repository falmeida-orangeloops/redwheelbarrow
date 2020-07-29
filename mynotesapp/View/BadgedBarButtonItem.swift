//
//  BadgedBarButtonItem.swift
//  mynotesapp
//
//  Created by Facundo Almeida on 7/29/20.
//  Copyright © 2020 Facundo Almeida. All rights reserved.
//

import UIKit

class BadgedBarButtonItem: UIBarButtonItem {
    @objc var badgeCount = 0 {
        didSet {
            updateBadgeLabel()
        }
    }
    
    @objc var badgeTag = 9830384
    @objc var badgeSize: CGFloat = 15
    @objc var badgeLabel: UILabel?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.badgeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: badgeSize, height: badgeSize))
        
        guard let badgeLabel = self.badgeLabel else {
            return
        }
        
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        badgeLabel.tag = badgeTag
        badgeLabel.layer.cornerRadius = badgeLabel.bounds.size.height / 2
        badgeLabel.textAlignment = .center
        badgeLabel.layer.masksToBounds = true
        badgeLabel.textColor = .white
        badgeLabel.font = badgeLabel.font.withSize(12)
        badgeLabel.backgroundColor = .systemRed
    }
    
    func addBadgeLabelAsSubview() {
        let view = (self.value(forKey: "view") as! UIView).subviews[0]
        
        guard view.subviews[0].subviews.isEmpty, let badgeLabel = self.badgeLabel else {
            return
        }
        
        view.subviews[0].addSubview(badgeLabel)
        
        NSLayoutConstraint.activate([
            badgeLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
            badgeLabel.topAnchor.constraint(equalTo: view.topAnchor),
            badgeLabel.widthAnchor.constraint(equalToConstant: badgeSize),
            badgeLabel.heightAnchor.constraint(equalToConstant: badgeSize)])
    }
    
    func updateBadgeLabel() {
        guard let badgeLabel = self.badgeLabel else {
            return
        }
        
        addBadgeLabelAsSubview()
        
        if badgeCount == 0 {
            badgeLabel.isHidden = true
            return
        }
        
        else {
            badgeLabel.isHidden = false
        }
        
        badgeLabel.text = String(badgeCount)
    }
}
