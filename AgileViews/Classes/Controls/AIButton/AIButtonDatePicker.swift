//
//  AIButtonDatePicker.swift
//
//
//  Created by Agile Infoways.
//  Copyright © 2017 Agile. All rights reserved.
//

import UIKit



open class AIButtonDatePicker: UIButton{
    
    //MARK:- PROPERTIES
    
    var pickerView                      : UIDatePicker?
    var toolBarForInputAccessoryView    : UIToolbar?
    var btnPressHandler                 : ((_ sender:AIButtonDatePicker) -> (Void))?
    var cancelHandler                   : ((_ sender:AIButtonDatePicker) -> (Void))?
    var pickerDoneHandler               : ((_ sender:AIButtonDatePicker) -> (Void))?
    var dateValueChangeHandler          : ((_ sender:AIButtonDatePicker) -> (Void))?
    var viewTransparent                 : UIView?
    
    
    public var Date: Date {
        get {
            return (self.pickerView?.date)!
        }
        set {
            self.pickerView?.date = (newValue)
        }
    }
    
    public var minimumDate: Date {
        get {
            return (self.pickerView?.minimumDate)!
        }
        set {
            self.pickerView?.minimumDate = (newValue)
        }
    }
    
    public var maximumDate: Date {
        get {
            return (self.pickerView?.maximumDate)!
        }
        set {
            self.pickerView?.maximumDate = (newValue)
        }
    }
    
    
    
    
    @IBInspectable
    /// Should the corner be as circle
    public var pickerType: UIDatePickerMode {
        get {
            return (self.pickerView?.datePickerMode)!
        }
        set {
            self.pickerView?.datePickerMode = newValue
        }
    }
    
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
    
    // MARK:- SETUP INPUT AND ACCESSORY VIEWS.
    func doSetupInputView(){
        
        // UIPICKERVIEW
        self.pickerView = UIDatePicker()
        self.pickerView!.backgroundColor = UIColor.white
        self.pickerView?.minimumDate = Date
        
        
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
    
    // MARK: - BUTTON HANDLER
    
    
    /// Button tap handler.
    ///
    /// - Parameter sender: UIButton
    @objc func btnTapHandler(sender:UIButton){
        
        self.showTransparentViewBehindKeyboard()
        
        self.becomeFirstResponder()
        if((self.btnPressHandler) != nil){
            self.btnPressHandler!(self)
        }
    }
    
    
    /// Cancel Button handler.
    ///
    /// - Parameter sender: UIButton
    @objc func btnCancelHandler(sender:UIButton) {
        
        self.resignFirstResponder()
        self.hideTransparentViewBehindKeyboard()
        
        if((self.cancelHandler) != nil){
            self.cancelHandler!(self)
        }
    }
    
    
    /// Done Button handler.
    ///
    /// - Parameter sender: UIButton
    @objc func btnDoneHandler(sender:UIButton) {
        
        self.resignFirstResponder()
        self.hideTransparentViewBehindKeyboard()
        
        if((self.pickerDoneHandler) != nil){
            self.pickerDoneHandler!(self)
        }
    }
    
    
    /// DatePicker value changet event.
    ///
    /// - Parameter sender: UIDatePicker
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






