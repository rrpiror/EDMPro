//
//  ShoppingItemTableViewCell.swift
//  EDMPro
//
//  Created by Rob Prior on 30/06/2018.
//  Copyright © 2018 Rob Prior. All rights reserved.
//

import UIKit
import SwipeCellKit

class ShoppingItemTableViewCell: SwipeTableViewCell {
    
    @IBOutlet var itemImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var extraInfoLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var quantityLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
    
    func bindData(item: ShoppingItem) {
        self.nameLabel.text = item.name
        self.extraInfoLabel.text = item.info
        self.quantityLabel.text = item.quantity
        self.priceLabel.text = "£\(String(format: "%.2f", item.price))"
        
        self.priceLabel.sizeToFit()
        self.nameLabel.sizeToFit()
        self.extraInfoLabel.sizeToFit()
        self.quantityLabel.sizeToFit()
        
        //addImage
        if item.image != "" {
            
            imageFromData(pictureData: item.image) { (image) in
                self.itemImageView.image = maskRoundedImage(image: image!, radius: Float(image!.size.width/2))
                
            }
            
        } else {
            var image: UIImage!
            
            if item.isBought {
                image = UIImage(named: "ShoppingCartFilled")
            } else {
                image = UIImage(named: "ShoppingCartSaved")
            }
            self.itemImageView.image = maskRoundedImage(image: image, radius: Float(image!.size.width/2))
            
        }
    }

}
