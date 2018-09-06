//
//  ProductItem.swift
//  EDMPro
//
//  Created by Rob Prior on 16/07/2018.
//  Copyright © 2018 Rob Prior. All rights reserved.
//

import Foundation

class ProductItem {
    
    var name: String
    var info: String
    var price: Float
    let ownerId: String
    var image: String
    var ProductItemId: String
    
    
    init(_name: String, _info: String = "", _price: Float, _image: String = "") {
        
        self.name = _name
        self.info = _info
        self.price = _price
        self.ownerId = FUser.currentId()
        self.image = _image
        self.ProductItemId = ""
        
    }
    
    init(dictionary: NSDictionary) {
        name = dictionary[kNAME] as! String
        info = dictionary[kINFO] as! String
        price = dictionary[kPRICE] as! Float
        ownerId = dictionary[kOWNERID] as! String
        image = dictionary[kIMAGE] as! String
        ProductItemId = dictionary[kPRODUCTITEMID] as! String
    }
    
    init(shoppingItem: ShoppingItem) {
        name = shoppingItem.name
        info = shoppingItem.info
        price = shoppingItem.price
        ownerId = FUser.currentId()
        image = shoppingItem.image
        ProductItemId = ""

    }
    
    func dictionaryFromItem(item: ProductItem) -> NSDictionary {
        
        return NSDictionary(objects: [item.name, item.info, item.price, item.ownerId, item.image, item.ProductItemId], forKeys: [kNAME as NSCopying, kINFO as NSCopying, kPRICE as NSCopying, kOWNERID as NSCopying, kIMAGE as NSCopying, kPRODUCTITEMID as NSCopying])
        
    }
    
    func saveItemInBackground(productItem: ProductItem, completion: @escaping (_ error: Error?) -> Void) {
        
        let ref = firebase.child(kPRODUCTITEM).child(FUser.currentId()).childByAutoId()
        
        productItem.ProductItemId = ref.key
        
        ref.setValue(dictionaryFromItem(item: productItem)) { (error, ref) -> Void in
            
            completion(error)
        }
        
    }
    
    func updateItemInBackground(productItem: ProductItem, completion: @escaping (_ error: Error?) -> Void) {
        
        let ref = firebase.child(kPRODUCTITEM).child(FUser.currentId()).child(productItem.ProductItemId)
        ref.setValue(dictionaryFromItem(item: productItem)) { (error, ref) -> Void in
            
            completion(error)
            
        }
    }
    
    func deleteItemInBackground(productItem: ProductItem) {
        
        let ref = firebase.child(kPRODUCTITEM).child(FUser.currentId()).child(productItem.ProductItemId)
        ref.removeValue()
        
    }
    
    
    
}
