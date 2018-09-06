//
//  ListTableViewCell.swift
//  EDMPro
//
//  Created by Rob Prior on 24/06/2018.
//  Copyright © 2018 Rob Prior. All rights reserved.
//

import UIKit
import SwipeCellKit

class ListTableViewCell: SwipeTableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var totalItemsLabel: UILabel!
    @IBOutlet var totalPriceLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func bindData(item: ShoppingList) {
        
        let currentDateFormatter = dateFormatter()
        currentDateFormatter.dateFormat = "dd/MM/yyyy"
        let date = currentDateFormatter.string(from: item.date)
        
        
        self.nameLabel.text = item.name
        self.totalItemsLabel.text = "\(item.totalItems) Items"
        self.totalPriceLabel.text = "Total Price £\(String(format: "%.2f", item.totalPrice))"
        self.dateLabel.text = date
        
        self.totalPriceLabel.sizeToFit()
        self.nameLabel.sizeToFit()
        
    }
    
}
