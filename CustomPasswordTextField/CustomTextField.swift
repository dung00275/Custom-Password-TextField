//
//  CustomTextField.swift
//  CustomPasswordTextField
//
//  Created by Dung Vu on 5/12/16.
//  Copyright © 2016 Zinio Pro. All rights reserved.
//

import Foundation
import UIKit
@IBDesignable
final public class CustomTextFieldPassword: UIView {
    
    @IBInspectable var characterPassword: String = "*"
    @IBInspectable var maxCharacter: Int = 20 {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 5 {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var borderWidth: CGFloat = 3 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var borderColor:UIColor? = UIColor.blueColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var leftSpaceText:CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var sizeOfFontText:CGFloat = 20 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var _fontTextField:UIFont?
    
    var fontTextField:UIFont? {
        get{
            guard let font = self._fontTextField else {
                return UIFont.systemFontOfSize(sizeOfFontText)
            }
            return font
        }
        set(newValue){
            _fontTextField = newValue
            setNeedsDisplay()
        }
        
    }
    
    
    public private(set) var actualText: String?
    private var pasting: Bool = false
    private var textField:UITextField!
    private var leftSpaceTextField: NSLayoutConstraint!
    private var widthPassword: NSLayoutConstraint!
    private var tailView: CustomPasswordTailView!
    private var leftTailView: NSLayoutConstraint!
    
    // MARK: --- Setup
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }
    
    private func commonSetup() {
        if textField != nil {textField.removeFromSuperview()}
        
        self.textField = UITextField(frame: CGRect(origin: CGPointZero, size: self.bounds.size))
        self.textField.backgroundColor = UIColor.redColor()
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textField)
        
        self.textField.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        leftSpaceTextField = self.textField.leftAnchor.constraintEqualToAnchor(self.leftAnchor)
        leftSpaceTextField.active = true

        let size =  createStringPassword(maxCharacter).calculateSizeForPassWord(fontTextField)
        widthPassword = self.textField.widthAnchor.constraintEqualToConstant(size.width)
        widthPassword.active = true
        
        self.textField.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor).active = true
        
        self.textField.delegate = self
        self.textField.autocorrectionType = .No
        
        setupTailView()
    }
    
    private func setupTailView() {
        if tailView == nil {
            tailView = CustomPasswordTailView(frame: CGRectZero)
        }
        
        tailView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tailView)
        
        tailView.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        let constant = leftSpaceText + widthPassword.constant
        leftTailView = tailView.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: constant)
        leftTailView.active = true
        tailView.rightAnchor.constraintEqualToAnchor(self.rightAnchor).active = true
        tailView.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor).active = true
        
    }
    
    
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor?.CGColor
        
        leftSpaceTextField.constant = leftSpaceText
        let size = createStringPassword(maxCharacter).calculateSizeForPassWord(fontTextField,
                                                                               maxHeight: self.bounds.height)
        widthPassword.constant = size.width
        let constant = leftSpaceText + widthPassword.constant
        leftTailView.constant = constant
        textField.font = fontTextField
        self.layoutIfNeeded()
    }

    deinit {
        print("\(#function)) class: \(self.dynamicType)")
    }
}

// MARK: --- Custom delegate
extension CustomTextFieldPassword: UITextFieldDelegate {
    // Create Password string
    func createStringPassword(length: Int) -> String {
        var result = ""
        for _ in 0..<length {result += characterPassword.subString(NSMakeRange(0, 1))}
        return result
    }
    
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        
        guard let newIndex = textField.text?.startIndex else {
            return false
        }
        
        // Check Max lenght
        if let newText = textField.text?.stringByReplacingCharactersInRange(newIndex..<newIndex.advancedBy(range.length), withString: string) where newText.characters.count > maxCharacter {
            return false
        }
        
        if actualText == nil {actualText = ""}
        
        if !pasting {
            
            if textField.text == nil || (textField.text?.characters.count == 0 && string == "") {
                pasting = true
                actualText = nil
                return true
            }
            
            // Update Value Use
            self.actualText =  self.actualText?.stringByReplacingCharactersInRange(newIndex..<newIndex.advancedBy(range.length), withString: string)
            
            if string == "" {return true}
            
            let sec = createStringPassword(string.characters.count)
            pasting = true
            UIPasteboard.generalPasteboard().string = sec
            textField.paste(self)
            
            // Clear pasteboard
            UIPasteboard.generalPasteboard().setValue("",
                                                      forPasteboardType: UIPasteboardNameGeneral)
            
            
            return false
        }else {
            pasting = false
            return true
        }
    }
}

extension String {
    
    func calculateSizeForPassWord(font: UIFont?,
                                  maxWidth: CGFloat = CGFloat.max,
                                  maxHeight:CGFloat = CGFloat.max) -> CGSize
    {
        guard let font = font else {return CGSizeZero}
        let containSize = CGSizeMake(maxWidth, maxHeight)
        
        let rect = self.boundingRectWithSize(containSize,
                                             options: [.UsesFontLeading],
                                             attributes: [NSFontAttributeName: font],
                                             context: nil)
        
        
        return rect.size
    }
    
    func subString(range:NSRange) -> String{
        let newIndex = startIndex.advancedBy(range.location)
        return self.substringWithRange(newIndex..<newIndex.advancedBy(range.length))
    }
}

