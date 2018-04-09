//
//  AITextField.swift
//
//
//  Created by Agile Infoways.
//  Copyright © 2017 Agile. All rights reserved.
//


import UIKit


open class AITextField: UITextField {
    
    //MARK:- PROPERTIES
    
    public typealias Config = (AITextField) -> Swift.Void
    public func configure(configurate: Config?) {
        configurate?(self)
    }
    
    public typealias Action = (UITextField) -> Void
    fileprivate var actionEditingChanged: Action?
    
    public var leftViewPadding          : CGFloat?
    public var leftTextPadding          : CGFloat?
    public var shouldPreventAllActions  : Bool = false
    public var canCut                   : Bool = true
    public var canCopy                  : Bool = true
    public var canPaste                 : Bool = true
    public var canSelect                : Bool = true
    public var canSelectAll             : Bool = true
    public var needToLayoutSubviews     : Bool = true
    private var appPlaceholderColor     : UIColor? = UIColor()
    
    
    //MARK:- IBINSPECTABLE
    
    @IBInspectable
    /// Should the corner be as circle.
    public var placeholderColor: UIColor {
        get {
            return self.appPlaceholderColor!
        }
        set {
            self.appPlaceholderColor =  newValue
            if(self.placeholder != nil ){
                self.placeholder(text: self.placeholder!, color: self.appPlaceholderColor!)
            }else{
                self.setPlaceHolderTextColor(self.appPlaceholderColor!)
           }
        }
    }
    
    
    @IBInspectable
    /// Should the corner be as circle.
    public var tintcolor: UIColor {
        get {
            return self.tintColor!
        }
        set {
            self.tintColor = newValue
        }
    }
    
    
    @IBInspectable
    /// Should the corner be as circle.
    public var textcolor: UIColor {
        get {
            return self.textColor!
        }
        set {
            self.textColor = newValue
        }
    }
    
    
    //MARK:- INIT
    
    override init(frame: CGRect) {
        super.init(frame: frame)
         self.commonInit()
     }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    // Provides left padding for images
    override open func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftViewPadding ?? 0
        return textRect
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: (leftTextPadding ?? 8) + (leftView?.frame.size.width ?? 0) + (leftViewPadding ?? 0), dy: 0)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: (leftTextPadding ?? 8) + (leftView?.frame.size.width ?? 0) + (leftViewPadding ?? 0), dy: 0)
    }
    
    override open func layoutSubviews() {
		super.layoutSubviews()
		
		if self.needToLayoutSubviews {
			self.needToLayoutSubviews = false
		}
	}

    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
		
		if(self.shouldPreventAllActions){
			return false
		}
        
		switch action {
		case #selector(UIResponderStandardEditActions.cut(_:)):
			return self.canCut ? super.canPerformAction(action, withSender: sender) : self.canCut
		case #selector(UIResponderStandardEditActions.copy(_:)):
			return self.canCopy ? super.canPerformAction(action, withSender: sender) : self.canCopy
		case #selector(UIResponderStandardEditActions.paste(_:)):
			return self.canPaste ? super.canPerformAction(action, withSender: sender) : self.canPaste
		case #selector(UIResponderStandardEditActions.select(_:)):
			return self.canSelect ? super.canPerformAction(action, withSender: sender) : self.canSelect
		case #selector(UIResponderStandardEditActions.selectAll(_:)):
			return self.canSelectAll ? super.canPerformAction(action, withSender: sender) : self.canSelectAll
		default:
			return super.canPerformAction(action, withSender: sender)
		}
	}
    
    
    // MARK:-
    
    
    /// Action edit changed
    ///
    /// - Parameter closure: your action.
    public func action(closure: @escaping Action) {
        if actionEditingChanged == nil {
            addTarget(self, action: #selector(AITextField.textFieldDidChange), for: .editingChanged)
        }
        actionEditingChanged = closure
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        actionEditingChanged?(self)
    }
    
    
    /// Default property set methord.
    func commonInit(){
        // self.font = (appFont != nil) ? appFont :   UIFont.systemFont(ofSize: self.font!.pointSize)
        self.autocorrectionType = .no
    }
}


private extension UITextField {
    
    /// Set placeholder text color.
    ///
    /// - Parameter color: placeholder text color.
    func setPlaceHolderTextColor(_ color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: color])
    }
    
    /// Set placeholder text and its color
    func placeholder(text value: String, color: UIColor = .red) {
        self.attributedPlaceholder = NSAttributedString(string: value, attributes: [ NSAttributedStringKey.foregroundColor : color])
    }
}


