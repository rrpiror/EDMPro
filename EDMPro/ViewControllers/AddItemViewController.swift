//
//  AddItemViewController.swift
//  EDMPro
//
//  Created by Rob Prior on 30/06/2018.
//  Copyright © 2018 Rob Prior. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    @IBOutlet var itemImageView: UIImageView!
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var extraInfoTextField: UITextField!
    @IBOutlet var quantityTextField: UITextField!
    @IBOutlet var priceTextField: UITextField!
    
    var shoppingList: ShoppingList!
    var shoppingItem: ShoppingItem?
    var productItem: ProductItem?
    
    var addingToList: Bool?
    
    var itemImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "ShoppingCartSaved")
        itemImageView.image = maskRoundedImage(image: image!, radius: Float(image!.size.width/2))
        
        if shoppingItem != nil || productItem != nil {
            updateUI()
        }
    }
    
    //MARK: IBAction
    
    @IBAction func addImageButtonPressed(_ sender: Any) {
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = Camera(delegate_: self)
        
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { (alert: UIAlertAction!) in
            
            camera.PresentPhotoCamera(target: self, canEdit: true)
            
        }
        
        let sharePhoto = UIAlertAction(title: "Photo Library", style: .default) { (alert: UIAlertAction!) in
            
            camera.PresentPhotoLibrary(target: self, canEdit: true)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert: UIAlertAction!) in
            
        }
        
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(sharePhoto)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        if priceTextField.text == "" {
            priceTextField.text = "0"
        }
        
        if nameTextField.text != "" && priceTextField.text != "" {
            
            if shoppingItem != nil || productItem != nil {

                self.updateItem()

            } else {

                self.saveItem()
            }
           
        } else {
            
            self.createError(title: "You must enter a Name and Price", message: "")
        }
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Saving Item
    
    func updateItem() {
        var imageData: String!
        if itemImage != nil {
            let image = UIImageJPEGRepresentation(itemImage!, 0.5)//  itemImage!.jpegData(compressionQuality: 0.5)!
            //let image = itemImage!.jpegData(compressionQuality: 0.5)!
            imageData = image?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        } else {
            imageData = ""
        }
        
        if shoppingItem != nil {
            
            shoppingItem!.name = nameTextField.text!
            shoppingItem!.price = Float(priceTextField.text!)!
            shoppingItem!.quantity = quantityTextField.text!
            shoppingItem!.info = extraInfoTextField.text!
            
            shoppingItem!.image = imageData
            
            shoppingItem!.updateItemInBackground(shoppingItem: shoppingItem!) { (error) in
                if error != nil {
                    self.createError(title: "Error updating item", message: "")
                    return
                }
            }
            
        } else if productItem != nil {
            
            productItem!.name = nameTextField.text!
            productItem!.price = Float(priceTextField.text!)!
            productItem!.info = extraInfoTextField.text!
            
            productItem!.image = imageData
            
            productItem!.updateItemInBackground(productItem: productItem!) { (error) in
                
                if error != nil {
                    self.createError(title: "Error updating product", message: "")
                    return
                }
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    

    
    func saveItem() {
        
        var shoppingItem: ShoppingItem
        
        var imageData: String!
        
            if itemImage != nil {
                let image = UIImageJPEGRepresentation(itemImage!, 0.5)//  itemImage!.jpegData(compressionQuality: 0.5)!
                imageData = image?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            } else {
            imageData = ""
            }
        
        
        if addingToList! {
            
            //add to groceryList only
            shoppingItem = ShoppingItem(_name: nameTextField.text!, _info: extraInfoTextField.text!, _price: Float(priceTextField.text!)!, _shoppingListId: "")
            
            let productItem = ProductItem(shoppingItem: shoppingItem)
            productItem.image = imageData
            
            productItem.saveItemInBackground(productItem: productItem) { (error) in
                
                if error != nil {
                    
                    self.createError(title: "\(error!.localizedDescription)", message: "")
                    
                    return
                }
            
            }
            
            
            self.dismiss(animated: true, completion: nil)
            
            
        } else {
            
            //add to current item, give option to add to list as well?
            shoppingItem = ShoppingItem(_name: nameTextField.text!, _info: extraInfoTextField.text!, _quantity: quantityTextField.text!, _price: Float(priceTextField.text!)!, _shoppingListId: shoppingList.id)
            
            shoppingItem.image = imageData
            
            
            shoppingItem.saveItemInBackground(shoppingItem: shoppingItem) { (error) in
                
                if error != nil {
                    
                    self.createError(title: "\(error!.localizedDescription)", message: "")
                    
                    return
                }
                
            }
            
            showListNotification(shoppingItem: shoppingItem)
        }
    }
        
    
    func showListNotification(shoppingItem: ShoppingItem) {
        
        let alertController = UIAlertController(title: "New Product", message: "Would you like to add this product to 'My Products'", preferredStyle: .actionSheet)
        
        let noAction = UIAlertAction(title: "No", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            //save to my products
            let productItem = ProductItem(shoppingItem: shoppingItem)
            productItem.saveItemInBackground(productItem: productItem, completion: { (error) in
                if error != nil {
                    self.createError(title: "Error adding product to My Products", message: "")
                }
            })
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    //MARK: UIImagePickerController Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.itemImage = (info[UIImagePickerControllerEditedImage] as! UIImage)
        self.itemImageView.image = maskRoundedImage(image: itemImage!, radius: Float(itemImage!.size.width / 2))
        
        picker.dismiss(animated: true, completion: nil)

    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        self.itemImage = (info[UIImagePickerController.InfoKey.editedImage] as! UIImage)
//        self.itemImageView.image = maskRoundedImage(image: itemImage!, radius: Float(itemImage!.size.width / 2))
//
//        picker.dismiss(animated: true, completion: nil)
//    }
    
    
    //MARK: UpdateUI
    
    func updateUI() {
        if shoppingItem != nil {
            
            self.nameTextField.text = self.shoppingItem!.name
            self.extraInfoTextField.text = self.shoppingItem!.info
            self.quantityTextField.text = self.shoppingItem!.quantity
            self.priceTextField.text = "\(self.shoppingItem!.price)"
            
            if shoppingItem!.image != "" {
                imageFromData(pictureData: shoppingItem!.image, withBlock: { (image) in
                    
                    itemImageView.image = maskRoundedImage(image: image!, radius: Float(image!.size.width/2))
                    
                })
                
            }
            
        } else if productItem != nil {
            
            self.nameTextField.text = self.productItem!.name
            self.extraInfoTextField.text = self.productItem!.info
            self.quantityTextField.text = ""
            self.priceTextField.text = "\(self.productItem!.price)"
            
            if productItem!.image != "" {
                imageFromData(pictureData: productItem!.image, withBlock: { (image) in
                    
                    itemImageView.image = maskRoundedImage(image: image!, radius: Float(image!.size.width/2))
                    
                })
                
            }
            
        }
    }
    
    //MARK: HELPER FUNCTIONS
    
    func createError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }

    
}
