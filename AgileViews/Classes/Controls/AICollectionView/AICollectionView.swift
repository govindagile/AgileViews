//
//  AICollectionView.swift
//
//
//  Created by Agile Infoways.
//  Copyright © 2017 Agile. All rights reserved.
//


import UIKit

class AICollectionView: UICollectionView , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	
	//MARK:- PROPERTIES
	private var viewPlaceHolder:AIViewPlaceHolder!
	
    
    /// App Loader in collection view background
    var isAddLoader: Bool? {
        set {
            if newValue == true {
                self.viewPlaceHolder = AIViewPlaceHolder()
                self.addSubview(self.viewPlaceHolder)
            }else{
                if viewPlaceHolder != nil{
                    self.viewPlaceHolder.removeFromSuperview()
                }
                
            }
        }
        get {
            return self.isAddLoader
        }
    }
   
	
	//MARK:- INIT
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
    }
	
	override func awakeFromNib() {
		super.awakeFromNib()
		commonInit()
	}
	
	private func commonInit(){
		self.delegate = self
		self.dataSource = self
		self.showsVerticalScrollIndicator = false
		self.showsHorizontalScrollIndicator = false
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
	}
	
	
    /// Add loader in collection view
    ///
    /// - Parameters:
    ///   - message: your message(String)
    ///   - andImageName: your image name(String)
    func showLoaderWithText(message: String? = "", andImageName : String? = ""){
        if self.viewPlaceHolder == nil {
            self.isAddLoader = true
        }
        self.viewPlaceHolder.setupPlaceHolderViewWith(message: message!, andImageName: andImageName!)
    }
    
    
    /// Add loader
    func showLoader(){
        if viewPlaceHolder == nil {
            self.isAddLoader = true
        }
        self.viewPlaceHolder.showLoader()
    }
    
    
    /// Hide Loader
    func hideLoader(){
        self.viewPlaceHolder.hideLoader()
    }

	
	
	//MARK:- DATASOURCE
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 1
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		return UICollectionViewCell(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
	}
	
	//MARK:- DELEGATE
}
