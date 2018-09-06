//
//  MyProductsTableViewCell.swift
//  EDMPro
//
//  Created by Rob Prior on 16/07/2018.
//  Copyright © 2018 Rob Prior. All rights reserved.
//

import UIKit

class MyProductsTableViewCell: ShoppingItemTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.quantityLabel.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    
    func bindDta(item: ProductItem) {
        self.nameLabel.text = item.name
        self.extraInfoLabel.text = item.info
        self.priceLabel.text = "£\(String(format: "%.2f", item.price))"
        
        if item.image != "" {
            imageFromData(pictureData: item.image, withBlock: { (image) in
                
                self.itemImageView.image = maskRoundedImage(image: image!, radius: Float(image!.size.width/2))
            })
        } else {
            let image = UIImage(named: "ShoppingCartFilled")
            self.itemImageView.image = maskRoundedImage(image: image!, radius: Float(image!.size.width/2))
        }
    }

}
