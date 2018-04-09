//
//  AILabel.swift
//
//
//  Created by Agile Infoways.
//  Copyright © 2017 Agile. All rights reserved.
//


import UIKit


open class AILabel: UILabel {
    
    //MARK:- PROPERTIES
    
    public typealias Action = (AILabel) -> Swift.Void
    fileprivate var actionOnTouch: Action?
    open var insets: UIEdgeInsets = .zero
    
    
    //MARK:- INIT
    
    override open func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    // Override -intrinsicContentSize: for Auto layout code
    override open var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += insets.top + insets.bottom
        contentSize.width += insets.left + insets.right
        return contentSize
    }
    
    // Override -sizeThatFits: for Springs & Struts code
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var contentSize = super.sizeThatFits(size)
        contentSize.height += insets.top + insets.bottom
        contentSize.width += insets.left + insets.right
        return contentSize
    }
    
    
    // MARK:-
    
    /// Return you click event on label click
    ///
    /// - Parameter closure: Action
    public func action(_ closure: @escaping Action) {
        print("action did set")
        if actionOnTouch == nil {
            let gesture = UITapGestureRecognizer(
                target: self,
                action: #selector(AILabel.actionOnTouchUpInside))
            gesture.numberOfTapsRequired = 1
            gesture.numberOfTouchesRequired = 1
            self.addGestureRecognizer(gesture)
            self.isUserInteractionEnabled = true
        }
        self.actionOnTouch = closure
    }
    
    
    
    /// UILabel Action
    @objc internal func actionOnTouchUpInside() {
        actionOnTouch?(self)
    }
    
    
    /// Default methords
    private func commonInit(){
     
    }
    
}



