//
//  ViewController2.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 13.09.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    var switchLogs = SwitchLogs()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switchLogs.forViewControllers(method: "\(#function)", numOfController: 2)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switchLogs.forViewControllers(method: "\(#function)", numOfController: 2)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        switchLogs.forViewControllers(method: "\(#function)", numOfController: 2)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
       switchLogs.forViewControllers(method: "\(#function)", numOfController: 2)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        switchLogs.forViewControllers(method: "\(#function)", numOfController: 2)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       switchLogs.forViewControllers(method: "\(#function)", numOfController: 2)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        switchLogs.forViewControllers(method: "\(#function)", numOfController: 2)
    }
}
