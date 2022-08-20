//
//  MWMethod2VC.swift
//  MWTextFieldMaxLengthDemo
//
//  Created by Horizon on 20/08/2022.
//

import UIKit

class MWMethod2VC: UIViewController {

    
    // MARK: - properties
    lazy var textField = UITextField(frame: .zero)
    
    // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1.0
        textField.placeholder = "最多可输入6个字"
        textField.delegate = self
        view.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(120.0)
            make.leading.trailing.equalToSuperview().inset(20.0)
            make.height.equalTo(50.0)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.endEditing(true)
    }
    
    // MARK: - init
    
    
    // MARK: - utils
    
    
    // MARK: - action
    
    
    // MARK: - other


}

extension MWMethod2VC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 6
    }
}
