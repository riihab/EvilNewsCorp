//
//  ViewController.swift
//  EvilNewsCorp
//
//  Created by Rihab Mehboob on 11/05/2024.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let mainViewController = MainViewController()
        mainViewController.modalPresentationStyle = .fullScreen
        present(mainViewController, animated: false)
    }

}

