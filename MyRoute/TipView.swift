//
//  LocationButton.swift
//  MyRoute
//
//  Created by xiaoming han on 14-7-21.
//  Copyright (c) 2014 AutoNavi. All rights reserved.
//

import UIKit

class TipView: UIView {

    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        
        self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
        label = UILabel(frame: CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)))
        
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.systemFontOfSize(20)
        label.textAlignment = NSTextAlignment.Center
        label.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        
        self.addSubview(label)
    }
    
    func showTip(tip: String?) {
        label.text = tip
        self.hidden = false
    }
}
