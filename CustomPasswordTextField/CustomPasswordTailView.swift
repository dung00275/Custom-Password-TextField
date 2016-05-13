//
//  CustomPasswordTailView.swift
//  CustomPasswordTextField
//
//  Created by Dung Vu on 5/13/16.
//  Copyright © 2016 Zinio Pro. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CustomPasswordTailView: UIView {
    
    @IBOutlet weak var lblPasword: UILabel!
    var action: (() -> ())?
    
    // Our custom view from the XIB file
    var view: UIView!
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        xibSetup()
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
    }
    
    private func commonSetup() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(CustomPasswordTailView.actionForgotPass))
        gesture.numberOfTapsRequired = 1
        
        lblPasword.addGestureRecognizer(gesture)
    }
    
    func xibSetup() {
        self.backgroundColor = UIColor.clearColor()
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        
        addSubview(view)
        
        // Add connect label
        let label = view.viewWithTag(450) as? UILabel
        lblPasword = label
        
        commonSetup()
        
    }
    
    
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "CustomPasswordTailView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
    
    
    @objc private func actionForgotPass() {
        
    }
}
