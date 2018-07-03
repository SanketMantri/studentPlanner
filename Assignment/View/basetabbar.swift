//
//  basetabbar.swift
//  Assignment
//
//  Created by Sanket Mantri on 19/10/17.
//  Copyright © 2017 Sanket Mantri. All rights reserved.
//

import Foundation
import UIKit
class BaseTabBarController: UITabBarController {
    
    @IBInspectable var defaultIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = defaultIndex
    }
    
}
