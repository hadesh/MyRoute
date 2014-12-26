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
    
    private var textView: UITextView
    private var control: UIButton
    private var originalFrame: CGRect
    private var isOpen: Bool
    
    override init(frame: CGRect) {
        
        isOpen = true
        textView = UITextView(frame: CGRectMake(0, controlHeight, CGRectGetWidth(frame), CGRectGetHeight(frame)))
        control = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        originalFrame = frame
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
        
                ///
        textView.backgroundColor = UIColor.clearColor()
        textView.textColor = UIColor.whiteColor()
        textView.font = UIFont.systemFontOfSize(12)
        textView.editable = false
        textView.selectable = false
        textView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        
        addSubview(textView)
        
        ///
        control.frame = CGRectMake(0, 0, CGRectGetWidth(frame), controlHeight)
        control.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
        control.titleLabel!.font = UIFont.systemFontOfSize(16)
        control.setTitle("Opened", forState: UIControlState.Normal)
        control.addTarget(self, action: "actionSwitch", forControlEvents: UIControlEvents.TouchUpInside)
        
        addSubview(control)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func actionSwitch() {
        isOpen = !isOpen
        
        if isOpen {
            control.setTitle("Opened", forState: UIControlState.Normal)
            
            UIView.animateWithDuration(0.25, animations: {
                self.frame = self.originalFrame
                
                self.textView.frame = CGRectMake(0, self.controlHeight, CGRectGetWidth(self.originalFrame), CGRectGetHeight(self.originalFrame))
                })
        }
        else {
            control.setTitle("Closed", forState: UIControlState.Normal)
            
            UIView.animateWithDuration(0.25, animations: {
                self.frame = CGRectMake(self.originalFrame.origin.x, self.originalFrame.origin.y, self.originalFrame.size.width, self.controlHeight)
                
                self.textView.frame = CGRectMake(0, self.controlHeight, CGRectGetWidth(self.originalFrame), 0)
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








