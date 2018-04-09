//
//  AITableView.swift
//
//
//  Created by Agile Infoways.
//  Copyright © 2017 Agile. All rights reserved.
//


import UIKit

class AITableView: UITableView, UITableViewDelegate, UITableViewDataSource {

	//MARK:- PROPERTIES
	private var viewPlaceHolder:AIViewPlaceHolder!
    private var refreshControlTable:UIRefreshControl!
    private var refreshTintColor : UIColor!
    

    /// App Loader in table view background
    var isAddLoader: Bool? {
        set {
            if newValue == true {
                self.viewPlaceHolder = AIViewPlaceHolder()
                self.showLoaderWithText(message: "NO DATA FOUND", andImageName: "")
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
    
    /// Pulltorefress add in table view background
	var isPullToRefreshEnabled:Bool {
		set {
			if newValue == true {
                self.refreshControlTable = UIRefreshControl()
				self.addSubview(refreshControlTable)
			}else{
                if refreshControlTable != nil{
                   refreshControlTable.removeFromSuperview()
                }
				
			}
		}
		get {
			return self.isPullToRefreshEnabled
		}
	}
    
    
    /// Set tint color
    open var tintcolor: UIColor!{
        set {
            refreshControlTable.tintColor = newValue
            refreshTintColor = newValue
        }
        get {
            if refreshTintColor != nil{
                return self.refreshControlTable.tintColor
            }else{
                return UIColor.green
            }
        }
    }
    
	
	// FOR PAGINATION
	var recordLimit:Int = 1
	var recordTotal:Int = 0
	
    // Block Handle
	var blockRefreshHandler:(()->Void)?
	var blockWillDisplayCellForIndexPath:((_ indexPath:IndexPath)->Void)?
	
	
	//MARK:- INIT
	override init(frame: CGRect, style: UITableViewStyle) {
		super.init(frame: frame, style: style)
		commonInit()
	}
	
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
		self.separatorStyle = .none
		
		self.estimatedRowHeight = 100
		self.rowHeight = UITableViewAutomaticDimension
		self.showsVerticalScrollIndicator = false
		self.keyboardDismissMode = .interactive
		
		
		// PULL TO REFRESH
		refreshControlTable = UIRefreshControl()
		refreshControlTable.attributedTitle = NSAttributedString(string: "Pull to refresh",
                                                                 attributes: [NSAttributedStringKey.foregroundColor: UIColor.green,NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: CGFloat(12).proportionalFontSize())])
		refreshControlTable.tintColor = tintcolor
		refreshControlTable.addTarget(self, action: #selector(self.refresh(sender:)), for: .valueChanged)
	}
	
	@objc func refresh(sender:UIRefreshControl) {
		print("\n\n PULL TO REFRESH")
		
		if self.blockRefreshHandler != nil {
			self.blockRefreshHandler!()
		}
		
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
			sender.endRefreshing()
		}
	}

	
	//MARK:- SHOW / HIDE LOADER
    
    
    /// Add loader in table view
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

	
	//MARK:- DELEGATE
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return UITableViewCell(style: .default, reuseIdentifier: "cell")
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if self.blockWillDisplayCellForIndexPath != nil {
			self.blockWillDisplayCellForIndexPath!(indexPath)
		}
	}

	//MARK:- ANIMATE TABLE
	func animateTable() {
		self.reloadData()
		
		let cells = self.visibleCells
		let tableHeight: CGFloat = self.bounds.size.height
		
		for i in cells {
			let cell: UITableViewCell = i as UITableViewCell
			cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
		}
		
		var index = 0
		
		for a in cells {
			let cell: UITableViewCell = a as UITableViewCell
			
			UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveLinear, animations: {
				cell.transform = CGAffineTransform.identity
			}, completion: nil)
			
			index += 1
		}
	}
}


private extension CGFloat{
    
    func proportionalFontSize() -> CGFloat {
        
        var sizeToCheckAgainst = self
        
        switch UIDevice.deviceType {
        case .iPhone4or4s:
            sizeToCheckAgainst -= 2
            break
        case .iPhone5or5s:
            sizeToCheckAgainst -= 1
            break
        case .iPhone6or6s:
            sizeToCheckAgainst -= 0
            break
        case .iPhone6por6sp:
            sizeToCheckAgainst += 1
            break
        case .iPhoneX:
            sizeToCheckAgainst += 0
            break
        case .iPad:
            sizeToCheckAgainst += 10
            break
        }
        return sizeToCheckAgainst
    }
}

private extension UIDevice {
    
    enum DeviceType:Int {
        case iPhone4or4s
        case iPhone5or5s
        case iPhone6or6s
        case iPhone6por6sp
        case iPhoneX
        case iPad
    }
    
    static var deviceType : DeviceType {
        // Need to match width also because if device is in portrait mode height will be different.
        if UIDevice.screenHeight == 480 || UIDevice.screenWidth == 480 {
            return DeviceType.iPhone4or4s
        } else if UIDevice.screenHeight == 568 || UIDevice.screenWidth == 568 {
            return DeviceType.iPhone5or5s
        } else if UIDevice.screenHeight == 667 || UIDevice.screenWidth == 667{
            return DeviceType.iPhone6or6s
        } else if UIDevice.screenHeight == 736 || UIDevice.screenWidth == 736{
            return DeviceType.iPhone6por6sp
        } else if UIDevice.screenHeight == 812 || UIDevice.screenWidth == 812{
            return DeviceType.iPhoneX
        } else {
            return DeviceType.iPad
        }
    }
    
    static var screenHeight : CGFloat {
        return UIScreen.main.bounds.size.height
    }
    static var screenWidth : CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
}


class AITableView_TPKeyboard: UITableView, UITableViewDelegate, UITableViewDataSource {

	
	//MARK:- PROPERTIES
	var viewPlaceHolder:AIViewPlaceHolder!

    /// App Loader in collection view background
    open var addLoader: Bool? {
        didSet {
            self.viewPlaceHolder = AIViewPlaceHolder()
            self.addSubview(self.viewPlaceHolder)
        }
    }
    
	//MARK:- INIT
	override init(frame: CGRect, style: UITableViewStyle) {
		super.init(frame: frame, style: style)
		commonInit()
	}
	
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
		self.separatorStyle = .none
		
		self.estimatedRowHeight = 100
		self.rowHeight = UITableViewAutomaticDimension
		self.showsVerticalScrollIndicator = false
		self.keyboardDismissMode = .interactive
		
	}
	
	
	//MARK:- SHOW / HIDE LOADER
    func showLoaderWithText(message: String? = "", andImageName : String? = ""){
        if self.viewPlaceHolder == nil {
            self.addLoader = true
        }
        self.viewPlaceHolder.setupPlaceHolderViewWith(message: message!, andImageName: andImageName!)
    }
    
    func showLoader(){
        if viewPlaceHolder == nil {
            self.addLoader = true
        }
        self.viewPlaceHolder.showLoader()
    }
    
    func hideLoader(){
        self.viewPlaceHolder.hideLoader()
    }

	
	//MARK:- DELEGATE
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return UITableViewCell(style: .default, reuseIdentifier: "cell")
	}
	
	
	
	//MARK:- ANIMATE TABLE 
	
	func animateTable() {
		self.reloadData()
		let cells = self.visibleCells
		let tableHeight: CGFloat = self.bounds.size.height
		for i in cells {
			let cell: UITableViewCell = i as UITableViewCell
			cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
		}
		var index = 0
		for a in cells {
			let cell: UITableViewCell = a as UITableViewCell
			UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveLinear, animations: {
				cell.transform = CGAffineTransform.identity
			}, completion: nil)
			index += 1
		}
	}
}
