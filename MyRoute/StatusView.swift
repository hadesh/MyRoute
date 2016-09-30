//
//  StatusView.swift
//  MyRoute
//
//  Created by xiaoming han on 14-7-21.
//  Copyright (c) 2014 AutoNavi. All rights reserved.
//

import UIKit

class StatusView: UIView {

    let controlHeight: CGFloat = 20.0
    
    private var textView: UITextView!
    private var control: UIButton!
    private var originalFrame: CGRect = CGRect.zero
    private var isOpen: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        isOpen = true
        textView = UITextView(frame: CGRect(x: 0, y: controlHeight, width: self.frame.width, height: self.frame.height))
        control = UIButton(type: UIButtonType.custom)
        originalFrame = self.frame
        
        ///
        textView.backgroundColor = UIColor.clear
        textView.textColor = UIColor.white
        textView.font = UIFont.systemFont(ofSize: 12)
        textView.isEditable = false
        textView.isSelectable = false
        textView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        addSubview(textView)
        
        //
        control.frame = CGRect(x: 0, y: 0, width: frame.width, height: controlHeight)
        control.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        control.titleLabel!.font = UIFont.systemFont(ofSize: 16)
        control.setTitle("Opened", for: UIControlState.normal)
        control.addTarget(self, action: #selector(StatusView.actionSwitch), for: UIControlEvents.touchUpInside)
        
        addSubview(control)
    }
    
    func actionSwitch() {
        isOpen = !isOpen
        
        if isOpen {
            control.setTitle("Opened", for: UIControlState.normal)
            
            UIView.animate(withDuration: 0.25, animations: {
                self.frame = self.originalFrame
                
                self.textView.frame = CGRect(x: 0, y: self.controlHeight, width: self.originalFrame.width, height: self.originalFrame.height)
                })
        }
        else {
            control.setTitle("Closed", for: UIControlState.normal)
            
            UIView.animate(withDuration: 0.25, animations: {
                self.frame = CGRect(x: self.originalFrame.origin.x, y: self.originalFrame.origin.y, width: self.originalFrame.width, height: self.controlHeight)
                self.textView.frame = CGRect(x: 0, y: self.controlHeight, width: self.originalFrame.width, height: 0)
                })
        }
    }
    
    /// Interface
    
    func showStatusInfo(info: [(String, String)]?) {
        
        if info == nil {
            textView.text = ""
        }
        else {
            var text = ""
            for (title, content) in info! {
                text += "\(title):\n\(content)\n"
            }
            textView.text = text
        }
    }
}








