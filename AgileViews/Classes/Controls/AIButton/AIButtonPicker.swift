//
//  AIButtonPicker.swift
//
//
//  Created by Agile Infoways.
//  Copyright © 2017 Agile. All rights reserved.
//

import UIKit


open class AIButtonPicker: UIButton, UIPickerViewDataSource, UIPickerViewDelegate{
    
    //MARK:- PROPERTIES
    
    var pickerView                      : UIPickerView?
    var toolBarForInputAccessoryView    : UIToolbar?
    var arrDataSource                   : [AIPickerItem] = []
    var arrDataSource1                  : [AIPickerItem] = []
    var btnPressHandler                 : ((_ sender:AIButtonPicker) -> (Void))?
    var cancelHandler                   : ((_ sender:AIButtonPicker) -> (Void))?
    var doneHandler                     : ((_ sender:AIButtonPicker) -> (Void))?
    var dateValueChangeHandler          : ((_ sender:AIButtonPicker) -> (Void))?
    var viewTransparent                 : UIView?
    
    
    // MARK: - INIT
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.isExclusiveTouch = true
        self.doSetupInputView()
        self.backgroundColor = UIColor.clear
        
    }
    
    
    // MARK:- OVERRIDING
    override open var inputView: UIView? {
        get {
            return self.pickerView
        }
        set {
            self.inputView = self.pickerView
        }
    }
    
    override open var inputAccessoryView: UIView? {
        get {
            return self.toolBarForInputAccessoryView
        }
        set {
            self.inputAccessoryView = self.toolBarForInputAccessoryView
        }
    }
    
    override open var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK:- SETUP INPUT AND ACCESSORY VIEWS
    func doSetupInputView(){
        
        // UIPICKERVIEW
        self.pickerView = UIPickerView()
        self.pickerView!.backgroundColor = UIColor.white
        self.pickerView?.dataSource = self
        self.pickerView?.delegate = self
        
        
        // TOOLBAR ITEMS
        let btnCancel: UIButton = UIButton()
        btnCancel.setTitle("Cancel", for: .normal)
        btnCancel.setTitleColor(UIColor.init(red: 0/255, green: 122/255, blue: 255/255, alpha: 1), for: .normal)
        btnCancel.addTarget(self, action: #selector(self.btnCancelHandler(sender:)), for: .touchUpInside)
        btnCancel.sizeToFit()
        
        let btnDone: UIButton = UIButton()
        btnDone.setTitle("Done", for: .normal)
        btnDone.setTitleColor(UIColor.init(red: 0/255, green: 122/255, blue: 255/255, alpha: 1), for: .normal)
        btnDone.addTarget(self, action: #selector(self.btnDoneHandler(sender:)), for: .touchUpInside)
        btnDone.sizeToFit()
        
        let barBtnCancel: UIBarButtonItem = UIBarButtonItem.init(customView: btnCancel)
        let barBtnDone: UIBarButtonItem = UIBarButtonItem.init(customView: btnDone)
        let barBtnFlexibleSpace: UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // TOOLBAR
        self.toolBarForInputAccessoryView = UIToolbar()
        self.toolBarForInputAccessoryView!.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44)
        self.toolBarForInputAccessoryView!.barTintColor = UIColor.white
        self.toolBarForInputAccessoryView!.isTranslucent = true
        self.toolBarForInputAccessoryView!.items = [barBtnCancel,barBtnFlexibleSpace,barBtnDone]
        
        // ADDING TARGET
        self.addTarget(self, action: #selector(self.btnTapHandler(sender:)), for: .touchUpInside)
        
        
    }
    
    
    // MARK: - PICKERVIEW DELEGATE
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.arrDataSource1.count == 0 ? 1 : 2
    }
    
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        var rowsToReturn:Int = 0
        if(self.arrDataSource1.count == 0){
            rowsToReturn = self.arrDataSource.count
        }else{
            switch component {
            case 0:
                rowsToReturn = self.arrDataSource.count
            case 1:
                rowsToReturn = self.arrDataSource1.count
            default:
                break
            }
        }
        return rowsToReturn
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let lblTitle = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 30))
        lblTitle.textAlignment = .center
        lblTitle.textColor = UIColor.black
        
        
        var title:String = ""
        if(self.arrDataSource1.count == 0){
            title = self.arrDataSource[row].itemName
        }else{
            switch component {
            case 0:
                title = self.arrDataSource[row].itemName
            case 1:
                title = self.arrDataSource1[row].itemName
            default:
                break
            }
        }
        lblTitle.text = title
        return lblTitle
    }
    
    
    // MARK: - BUTTON HANDLER
    
    /// Button tap handler
    ///
    /// - Parameter sender: UIButton
    @objc func btnTapHandler(sender:UIButton){
        
        self.showTransparentViewBehindKeyboard()
        
        self.becomeFirstResponder()
        if((self.btnPressHandler) != nil){
            self.btnPressHandler!(self)
        }
    }
    
    
    /// Cancel Button handler
    ///
    /// - Parameter sender: UIButton
    @objc func btnCancelHandler(sender:UIButton) {
        
        self.resignFirstResponder()
        self.hideTransparentViewBehindKeyboard()
        
        if((self.cancelHandler) != nil){
            self.cancelHandler!(self)
        }
    }
    
    
    /// Done Button handler
    ///
    /// - Parameter sender: UIButton
    @objc func btnDoneHandler(sender:UIButton) {
        
        self.resignFirstResponder()
        self.hideTransparentViewBehindKeyboard()
        
        if((self.doneHandler) != nil){
            self.doneHandler!(self)
        }
    }
    
    func datePickerValueChangedHandler(sender: UIDatePicker) {
        
        if(self.dateValueChangeHandler != nil){
            self.dateValueChangeHandler!(self)
        }
    }
    
    
    //MARK:- SHOW / HIDE TRANSPARENT VIEW
    
    
    /// Show TransparentView.
    func showTransparentViewBehindKeyboard() {
        
        self.viewTransparent = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        self.viewTransparent!.backgroundColor = UIColor.black
        (UIApplication.shared.delegate)?.window??.addSubview(viewTransparent!)
        self.viewTransparent?.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
            self.viewTransparent?.alpha = 0.2
        }
    }
    
    /// Hide TransparentView.
    func hideTransparentViewBehindKeyboard() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.viewTransparent?.alpha = 0
        }) { (bbb) in
            self.viewTransparent?.removeFromSuperview()
        }
    }
    
}
