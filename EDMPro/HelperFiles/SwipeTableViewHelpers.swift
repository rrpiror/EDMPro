//
//  SwipeTableViewHelpers.swift
//  EDMPro
//
//  Created by Rob Prior on 02/07/2018.
//  Copyright © 2018 Rob Prior. All rights reserved.
//

import Foundation
import UIKit

enum ActionDescriptor {
    case save, returnPurchase, trash
    
    func title() -> String? {
        
        switch self {
        case .save: return "Save"
        case .returnPurchase: return "Return"
        case .trash: return "Delete"
            
        }
    }
    
    var colour: UIColor {
        switch self {
        case .save: return .lightGray
        case .returnPurchase: return .lightGray
        case .trash: return .red
        }
    }
    
    func image() -> UIImage? {
        
        let name: String
        switch self {
        case .save: name = "saveItem"
        case .returnPurchase: name = "ReturnFilled"
        case .trash: name = "Trash"
        }
        
        return UIImage(named: name)
    }
}

func createSelectedBackgroundView() -> UIView {
    
    let view = UIView()
    view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
    return view
}

