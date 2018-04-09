//
//  AIButton.swift
//
//
//  Created by Agile Infoways.
//  Copyright © 2017 Agile. All rights reserved.
//

import UIKit

open class AIButton: UIButton {
    
    
    //MARK:- PROPERTIES
    
    
    /// Get Click event using this
    public typealias Action = (AIButton) -> Swift.Void
    fileprivate var actionOnTouch: Action?
    
    
    //MARK:- INIT
    
    init() {
        super.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    // MARK:-
    
    
    /// Get click event of UIButton
    ///
    /// - Parameter closure: return action
    public func action(_ closure: @escaping Action) {
        if actionOnTouch == nil {
            addTarget(self, action: #selector(AIButton.actionOnTouchUpInside), for: .touchUpInside)
        }
        self.actionOnTouch = closure
    }
    
    @objc internal func actionOnTouchUpInside() {
        actionOnTouch?(self)
    }
    
    private func commonInit(){
        self.isExclusiveTouch = true
    }
}




public extension UIButton{
    
    
    /// Applay animation on button click
    ///
    /// - Parameter completion: return UIButton
    func animateSelectedStateWithAnimationOnCompletion(completion: @escaping () -> Void){
        
        // TO DISABLE QUICK NEW ANIMATION UNTIL PREVIOUS ONE COMPLETES
        self.isUserInteractionEnabled = false
        
        if(self.isSelected){
            
            UIView.transition(with: self, duration: 0.3, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
                self.isSelected = !self.isSelected
                
            }, completion: { (ss) in
                self.isUserInteractionEnabled = true
                completion()
            })
            return
        }
        
        
        UIView.animate(withDuration: 0.2 ,
                       animations: {
                        self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        },
                       completion: { finish in
                        
                        UIView.animate(withDuration: 0.2 ,
                                       animations: {
                                        self.isSelected = !self.isSelected
                                        self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                        },
                                       completion: { finish in
                                        
                                        
                                        UIView.animate(withDuration: 0.2 ,
                                                       animations: {
                                                        self.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                                        },
                                                       completion: { finish in
                                                        UIView.animate(withDuration: 0.2){
                                                            self.transform = CGAffineTransform.identity
                                                            self.isUserInteractionEnabled = true
                                                            completion()
                                                        }
                                        })
                        })
        })
        
    }
    
    
    /// Applay animation with perticular effect
    ///
    /// - Parameters:
    ///   - sameEffectOnStateChange: pass effect type
    ///   - completion: completion handler
    func animateSelectedStateWithAnimation(WithSameEffectOnStateChange sameEffectOnStateChange:Bool, OnCompletion completion: @escaping () -> Void){
        
        // TO DISABLE QUICK NEW ANIMATION UNTIL PREVIOUS ONE COMPLETES
        self.isUserInteractionEnabled = false
        
        if(self.isSelected){
            
            UIView.transition(with: self, duration: 0.3, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
                self.isSelected = !self.isSelected
                
            }, completion: { (ss) in
                self.isUserInteractionEnabled = true
                completion()
            })
            return
        }
        
        if(sameEffectOnStateChange){
            
            UIView.transition(with: self, duration: 0.3, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
                self.isSelected = !self.isSelected
                
            }, completion: { (ss) in
                self.isUserInteractionEnabled = true
                completion()
            })
            return
        }
        
        UIView.animate(withDuration: 0.2 ,
                       animations: {
                        self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        },
                       completion: { finish in
                        
                        UIView.animate(withDuration: 0.2 ,
                                       animations: {
                                        self.isSelected = !self.isSelected
                                        self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                        },
                                       completion: { finish in
                                        
                                        
                                        UIView.animate(withDuration: 0.2 ,
                                                       animations: {
                                                        self.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                                        },
                                                       completion: { finish in
                                                        UIView.animate(withDuration: 0.2){
                                                            self.transform = CGAffineTransform.identity
                                                            self.isUserInteractionEnabled = true
                                                            completion()
                                                        }
                                        })
                        })
        })
    }
    
}
