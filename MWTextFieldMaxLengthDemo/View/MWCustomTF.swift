//
//  MWCustomTF.swift
//  MWTextFieldMaxLengthDemo
//
//  Created by Horizon on 20/08/2022.
//

import UIKit

class MWCustomTF: UITextField {

    // MARK: - properties
    var kMaxInputLength: Int = 6
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addTarget(self, action: #selector(handleEditingChanged(_:)), for: UIControl.Event.editingChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - utils
    
    
    // MARK: - action
    @objc
    fileprivate func handleEditingChanged(_ sender: UITextField) {
        guard let text = sender.text else {
            return
        }
        if sender.markedTextRange != nil {
            return
        }
        
        let textCount = text.count
        let minCount = min(textCount, kMaxInputLength)
        self.text = (text as NSString).substring(to: minCount)
    }
    
    // MARK: - other

}
