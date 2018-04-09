//
//  AITextField.swift
//
//
//  Created by Agile Infoways.
//  Copyright © 2017 Agile. All rights reserved.
//


import UIKit



open class AITextPickerField: UITextField, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //MARK:- PROPERTIES
    
    public typealias Config = (AITextPickerField) -> Swift.Void
    public func configure(configurate: Config?) {
        configurate?(self)
    }
    public var leftViewPadding: CGFloat?
    public var leftTextPadding: CGFloat?
    public var needToLayoutSubviews    :Bool = true
    private var shouldPreventAllActions:Bool = true
    private var appPlaceholderColor  : UIColor? = UIColor()
    
 
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
    
    
    // Provides left padding for images.
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
         return true
    }
    
    
    /// Default property set methord
    func commonInit(){
        // self.font = (appFont != nil) ? appFont :   UIFont.systemFont(ofSize: self.font!.pointSize)
        self.autocorrectionType = .no
        self.isExclusiveTouch = true
        self.doSetupInputView()
    }
    
    //MARK:- PROPERTIES  FOR PICKERVIEW
    var pickerView                      : UIPickerView?
    var toolBarForInputAccessoryView    : UIToolbar?
    var arrDataSource                   : [AIPickerItem] = []
    var arrDataSource1                  : [AIPickerItem] = []
    var btnPressHandler                 : ((_ sender:AITextPickerField) -> (Void))?
    var cancelHandler                   : ((_ sender:AITextPickerField) -> (Void))?
    var doneHandler                     : ((_ sender:AITextPickerField) -> (Void))?
    var dateValueChangeHandler          : ((_ sender:AITextPickerField) -> (Void))?
    var selectedIndex                   : Int = 0
    var viewTransparent                 :UIView?
    
    
    // MARK: - INIT
    
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
    
    /// Default methord for set default value.
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
    
    
    // MARK: - PICKERVIEW DELEGATE.
    
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
    
    /// Cancel button handler.
    ///
    /// - Parameter sender: UIButton
    @objc func btnCancelHandler(sender:UIButton) {
        
        self.resignFirstResponder()
        self.hideTransparentViewBehindKeyboard()
        
        if((self.cancelHandler) != nil){
            self.cancelHandler!(self)
        }
    }
    
    /// Done button handler.
    ///
    /// - Parameter sender: UIButton
    @objc func btnDoneHandler(sender:UIButton) {
        
        self.selectedIndex = (self.pickerView?.selectedRow(inComponent: 0))!
        self.text = arrDataSource[self.selectedIndex].itemName
        
        self.resignFirstResponder()
        self.hideTransparentViewBehindKeyboard()
        
        if((self.doneHandler) != nil){
            self.doneHandler!(self)
        }
    }
    
    
    /// Date picker value handler.
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


