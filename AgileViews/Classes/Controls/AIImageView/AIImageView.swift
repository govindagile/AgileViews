//
//  AIImageView.swift
//
//
//  Created by Agile Infoways.
//  Copyright © 2017 Agile. All rights reserved.
//

import UIKit

open class AIImageView: UIImageView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}


/// Set ImageView with loader
open class AIImageViewLoader: AIImageView {

	//MARK:- INIT
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
    required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
    override open func awakeFromNib() {
		super.awakeFromNib()
		commonInit()
	}
	
	private func commonInit(){

		// LOADER IMAGES
		var arrImages = [UIImage]()
		for i in 0...61 { // 74
			if let image = UIImage(named: "loader_\(String(format: "%05d", i))") {
                arrImages.append(image)
			}
		}
		self.animationImages = arrImages
		self.animationDuration = 2.2
		self.animationRepeatCount = 0
		self.startAnimating()
	}

}


/// Set ImageView with fade effect
open class AIImageViewFade: AIImageView {
    
	@IBInspectable
	var fadeDuration: Double = 0.8
	
    override open var image: UIImage? {
		get {
			return super.image
		}
		set(newImage) {
			if let img = newImage {
				CATransaction.begin()
				CATransaction.setAnimationDuration(self.fadeDuration)
				
				let transition = CATransition()
				transition.type = kCATransitionFade
				
				super.layer.add(transition, forKey: kCATransition)
				super.image = img
				
				CATransaction.commit()
			} else {
				super.image = nil
			}
		}
	}
}
