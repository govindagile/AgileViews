//
//  AIViewPlaceHolder.swift
//
//
//  Created by Agile Infoways.
//  Copyright © 2017 Agile. All rights reserved.
//

import UIKit

class AIViewPlaceHolder: UIView {
	
	//MARK:- OUTLETS
	@IBOutlet private var contentView:UIView?
	@IBOutlet fileprivate weak var imageViewPlaceHolder: UIImageView!
	@IBOutlet fileprivate weak var imageViewLoader: UIImageView!
	@IBOutlet fileprivate weak var lblMessage: UILabel!
	@IBOutlet fileprivate weak var activityIndicatorView: UIActivityIndicatorView!

	var bgColor:UIColor {
		set {
			contentView?.backgroundColor = newValue
		}
		get {
			return UIColor.white
		}
	}
	
	
	// MARK:- INIT
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func commonInit()	{
		
		// LOADING NIB FILE
		Bundle.main.loadNibNamed("AIViewPlaceHolder", owner: self, options: nil)
		self.addSubview(self.contentView!);
		
		// UI
		self.contentView!.backgroundColor = UIColor.white

		// ACTIVITY INDICATOR
		self.activityIndicatorView.hidesWhenStopped = true
		
		// LOADER IMAGES
		var arrImages = [UIImage]()
		for i in 0...61 { // 74
			if let image =  UIImage(named: "loader_\(String(format: "%05d", i))"){
				arrImages.append(image)
			}
		}
		
        // Set image property
		self.imageViewLoader.animationImages = arrImages
		self.imageViewLoader.animationDuration = 2.2
		self.imageViewLoader.animationRepeatCount = 0
		self.imageViewLoader.startAnimating()
		self.imageViewLoader.isHidden = true
	}
	
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		if((self.superview) != nil){
			self.frame = CGRect(x: 0, y: 0, width: self.superview!.frame.size.width, height: self.superview!.frame.size.height)
			self.contentView?.frame = self.frame
		}
	}
	
    
    
	//MARK:- SETUP
	func setupPlaceHolderViewWith(message:String, andImageName placeHolderImageName:String){
		self.imageViewPlaceHolder.image = UIImage(named: placeHolderImageName)
		self.lblMessage.text = message
	}
	
	

	//MARK:- SHOW / HIDE LOADER
    
    /// Show loader on view.
	func showLoader(){
		self.imageViewLoader.isHidden = false
		self.lblMessage.isHidden = true
		self.imageViewPlaceHolder.isHidden = true
	}
    
    
    /// Hide loader on view.
	func hideLoader(){
		self.imageViewLoader.isHidden = true
		self.lblMessage.isHidden = false
		self.imageViewPlaceHolder.isHidden = false
	}

}
