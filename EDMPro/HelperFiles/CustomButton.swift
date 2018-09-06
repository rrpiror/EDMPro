//
//  Button.swift
//  EDMPro
//
//  Created by Rob Prior on 22/08/2018.
//  Copyright © 2018 Rob Prior. All rights reserved.
//

import Foundation
import UIKit

class CustomButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
        
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
    }
    

}
