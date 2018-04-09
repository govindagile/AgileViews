//
//  AITextView.swift
//
//
//  Created by Agile Infoways.
//  Copyright © 2017 Agile. All rights reserved.
//


import UIKit


open class AITextView: UITextView , UITextViewDelegate {
	
    
	//MARK:- PROPERTIES

    private struct Constants {
        static let defaultiOSPlaceholderColor = UIColor(red: 0.0, green: 0.0, blue: 0.0980392, alpha: 0.22)
    }
    private var placeholderLabelConstraints = [NSLayoutConstraint]()
    
    
    override open var font: UIFont! {
        didSet {
            if placeholderFont == nil {
                placeholderLabel.font = font
            }
        }
    }
    
    override open var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel.textAlignment = textAlignment
        }
    }
    
    override open var text: String! {
        didSet {
            placeholderLabel.isHidden = !text.isEmpty
        }
    }
    
    open let placeholderLabel: UILabel = UILabel()
    
    open var placeholderFont: UIFont? {
        didSet {
            let font = (placeholderFont != nil) ? placeholderFont : self.font
            placeholderLabel.font = font
        }
    }
    
    // MARK:- IBINSPECTABLE
    
    @IBInspectable open var placeholder: String = "" {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    @IBInspectable open var placeholderColor: UIColor = AITextView.Constants.defaultiOSPlaceholderColor {
        didSet {
            placeholderLabel.textColor = placeholderColor
        }
    }
    
    
    // MARK:- Blocks
    
    var blockTextViewShouldChangeTextInRangeWithReplacementText:((_ textView: UITextView, _ range: NSRange, _ text: String) -> Bool)?
	var blockTextViewDidEndEditing:(()->(Void))?
	var needToLayoutSubviews:Bool = true
	

	
	//MARK:- INIT
	override init(frame: CGRect, textContainer: NSTextContainer?) {
		super.init(frame: frame, textContainer: textContainer)
		self.commonInit()
	}
    required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
    override open func awakeFromNib() {
		super.awakeFromNib()
		self.commonInit()
	}
    override open func layoutSubviews() {
        super.layoutSubviews()
        
    }
	
    
    // MARK:-
    
    /// Set Default property
	private func commonInit() {
		
        self.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.delegate = self
		self.clipsToBounds = true
		
		// ADDING PLACEHOLDER LABEL
        placeholderLabel.font = font
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.textAlignment = textAlignment
        placeholderLabel.text = placeholder
        placeholderLabel.numberOfLines = 0
        placeholderLabel.backgroundColor = UIColor.clear
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholderLabel)
        updateConstraintsForPlaceholderLabel()
       
        // Hide show placeholder at init time
        placeholderLabel.isHidden = self.text.count > 0 ? true : false
    }
    
    /// Update placeholder constraints
    private func updateConstraintsForPlaceholderLabel() {
        var newConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(\(textContainerInset.left + textContainer.lineFragmentPadding))-[placeholder]",
            options: [],
            metrics: nil,
            views: ["placeholder": placeholderLabel])
        newConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(\(textContainerInset.top))-[placeholder]",
            options: [],
            metrics: nil,
            views: ["placeholder": placeholderLabel])
        newConstraints.append(NSLayoutConstraint(
            item: placeholderLabel,
            attribute: .width,
            relatedBy: .equal,
            toItem: self,
            attribute: .width,
            multiplier: 1.0,
            constant: -(textContainerInset.left + textContainerInset.right + textContainer.lineFragmentPadding * 2.0)
        ))
        removeConstraints(placeholderLabelConstraints)
        addConstraints(newConstraints)
        placeholderLabelConstraints = newConstraints
    }
	
	
	//MARK:- TEXTVIEW DELEGATE
	
    public func textViewDidEndEditing(_ textView: UITextView) {
		if(self.blockTextViewDidEndEditing != nil){
			self.blockTextViewDidEndEditing!()
		}
	}

    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        var shouldReturn:Bool = true
        
        if text == "\n" {
            return true
        }
        if(self.blockTextViewShouldChangeTextInRangeWithReplacementText != nil){
            shouldReturn = self.blockTextViewShouldChangeTextInRangeWithReplacementText!(textView, range, text)
        }
        
        let fullText = (textView.text! as NSString).replacingCharacters(in: range, with: text);
        placeholderLabel.isHidden = !fullText.isEmpty
        
        return shouldReturn
    }

}


