//
//  MWNormalCustomTF.swift
//  MWTextFieldMaxLengthDemo
//
//  Created by MorganWang on 20/08/2022.
//

import UIKit

class MWNormalCustomTF: UITextField {
    // MARK: - properties
    var kMaxInputLength: Int = 6 // 最大输入长度
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addTarget(self, action: #selector(handleTFChanged(_:)), for: UIControl.Event.editingChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - utils
    
    
    // MARK: - action
    @objc
    fileprivate func handleTFChanged(_ sender: UITextField) {
        guard let text = sender.text else {
            return
        }
        
        let textCount = text.count
        let minCount = min(textCount, kMaxInputLength)
        self.text = (text as NSString).substring(to: minCount)
    }
    
    // MARK: - other

}
