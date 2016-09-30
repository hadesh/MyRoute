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
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = NSTextAlignment.center
        label.autoresizingMask = UIViewAutoresizing.flexibleWidth
        
        self.addSubview(label)
    }
    
    func showTip(tip: String?) {
        label.text = tip
        self.isHidden = false
    }
}
