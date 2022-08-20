//
//  ViewController.swift
//  MWTextFieldMaxLengthDemo
//
//  Created by Horizon on 20/08/2022.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - properties
    
    
    // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    // MARK: - init
    
    
    // MARK: - utils
    
    
    // MARK: - action
    @IBAction func method1Action(_ sender: Any) {
        let targetVC = MWMethod1VC()
        navigationController?.pushViewController(targetVC, animated: true)
    }
    
    @IBAction func method2Action(_ sender: Any) {
        let targetVC = MWMethod2VC()
        navigationController?.pushViewController(targetVC, animated: true)
    }
    
    @IBAction func finalMethodAction(_ sender: Any) {
        let targetVC = MWFinalMethodVC()
        navigationController?.pushViewController(targetVC, animated: true)
    }
    
    
    // MARK: - other
    



}

