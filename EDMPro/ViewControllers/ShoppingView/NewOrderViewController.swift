//
//  NewOrderViewController.swift
//  EDMPro
//
//  Created by Rob Prior on 21/06/2018.
//  Copyright © 2018 Rob Prior. All rights reserved.
//

import UIKit
import SwipeCellKit
import MessageUI

class NewOrderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwipeTableViewCellDelegate, MyProductsViewControllerDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var itemsLeftLabel: UILabel!
    @IBOutlet var totalPriceLabel: UILabel!
    @IBOutlet var sendEmailButtonOutlet: UIButton!
    
    
    var shoppingList: ShoppingList!
    var shoppingItem: ShoppingItem!
    var shoppingItems: [ShoppingItem] = []
    var boughtItems: [ShoppingItem] = []
    
    var defaultOptions = SwipeTableOptions()
    var isSwipeRightEnabled = true
    
    var totalPrice: Float!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadShoppingItems()

    }
    
    //MARK: TableView Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return shoppingItems.count
        } else {
            return boughtItems.count
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ShoppingItemTableViewCell
        
        cell.delegate = self
        cell.selectedBackgroundView = createSelectedBackgroundView()
        
        var item: ShoppingItem!
        
        if indexPath.section == 0 {
            item = shoppingItems[indexPath.row]
        } else {
            item = boughtItems[indexPath.row]
        }
        cell.bindData(item: item)
        return cell
    }
    
    //MARK: Table View Delegates
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        var item: ShoppingItem!
        
        if indexPath.section == 0 {
            
            item = shoppingItems[indexPath.row]
        } else {
            item = boughtItems[indexPath.row]
        }
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddItemVC") as! AddItemViewController
        
        vc.shoppingList = shoppingList
        vc.shoppingItem = item
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var title: String!
        if section == 0 {
            title = "Items to be sent"
        } else {
            title = "Saved items for later"
        }
        return titleViewForTable(titleText: title)
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }

    //MARK: IBActions
    
    @IBAction func addBarButtonItemPressed(_ sender: Any) {
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
    
        let newItem = UIAlertAction(title: "Add New Item", style: .default) { (alert) in
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddItemVC") as! AddItemViewController
            
            vc.shoppingList = self.shoppingList
            vc.addingToList = false
            
            self.present(vc, animated: true, completion: nil)
    
        }
        
        let myProducts = UIAlertAction(title: "Add From My Products", style: .default) { (alert) in
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchVC") as! MyProductsViewController
            vc.delegate = self
            vc.clicktoEdit = false
            self.present(vc, animated: true, completion: nil)
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
            
        }
        
        optionMenu.addAction(newItem)
        optionMenu.addAction(myProducts)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
        
        
    }
    
    @IBAction func sendEmailButtonPressed(_ sender: Any) {
        
        if shoppingItems.count > 0 {
        
        let actionSheet = UIAlertController(title: "", message: "Are you sure you would like to send your order now?", preferredStyle: .actionSheet)
        
        let yesAction = UIAlertAction(title: "Yes, send my order", style: .default) { (UIAlertAction) in
            
            self.sendMailHandler()

            /*
            let mailComposeViewController = self.configureMailController()
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showMailError()
            }
            
            self.createError(title: "", message: "Order Sent")
            */
        }
        let noAction = UIAlertAction(title: "No, not yet", style: .destructive) { (UIAlertAction) in
            
        }
        actionSheet.addAction(yesAction)
        actionSheet.addAction(noAction)
        
        self.present(actionSheet, animated: true, completion: nil)
        
        } else {
            
            createError(title: "Your order is empty", message: "Looks like you need to add some items to your 'Items to be sent'")
        }
    }
    
    func sendMailHandler() {

        let actionSheet = UIAlertController(title: "", message: "Please select order type.", preferredStyle: .actionSheet)
        
        let deliverdAction = UIAlertAction(title: "Delivery", style: .default) { (UIAlertAction) in
            
            self.sendMailDeliveredHandler()
        }
        let collectionAction = UIAlertAction(title: "Collection", style: .default) { (UIAlertAction) in
            
            self.sendMailCollectionHandler()
        }
        let noAction = UIAlertAction(title: "Cancel", style: .destructive) { (UIAlertAction) in
            
        }
        actionSheet.addAction(deliverdAction)
        actionSheet.addAction(collectionAction)
        actionSheet.addAction(noAction)
        
        self.present(actionSheet, animated: true, completion: nil)

    }
    
    func sendMailDeliveredHandler() {
        
        DeliverInfoViewController.show(navvc: self.navigationController!) { (address, date, extra) in
            
            self.navigationController?.popToViewController(self, animated: false)
            
            let mailComposeViewController = self.configureMailController()
            if MFMailComposeViewController.canSendMail() {
                
                var content = self.getDataForEmailBody()
                
                content = "\(content)Address: \(address)\nDate: \(date)\nAdditional Info: \(extra)"
                
                mailComposeViewController.setMessageBody(content, isHTML: false)
                
                self.present(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showMailError()
            }

        }
    }
    
    func sendMailCollectionHandler() {
        
        let mailComposeViewController = self.configureMailController()
        if MFMailComposeViewController.canSendMail() {
            mailComposeViewController.setMessageBody( self.getDataForEmailBody(), isHTML: false)
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showMailError()
        }
        
        self.createError(title: "", message: "Order Sent")
    }
    
    @IBAction func backBarButtonItemPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "NewOrderToPurchaseOrdersViewController", sender: self)
        
        
    }
    
    
    //MARK: Load Shopping Items
    
    func loadShoppingItems() {
        
        firebase.child(kSHOPPINGITEM).child(shoppingList.id).queryOrdered(byChild: kSHOPPINGLISTID).queryEqual(toValue: shoppingList.id).observe(.value, with: {
            snapshot in
            
            self.shoppingItems.removeAll()
            self.boughtItems.removeAll()
            
            if snapshot.exists() {
                
                let allItems = (snapshot.value as! NSDictionary).allValues as NSArray
                
                
                for item in allItems {
                    
                    let currentItem = ShoppingItem.init(dictionary: item as! NSDictionary)
                    
                    if currentItem.isBought {
                        
                        self.boughtItems.append(currentItem)
                        
                    } else {
                        
                        self.shoppingItems.append(currentItem)
                        
                    }
                    
                }
                
            } else{
                
                print("no snapshot")
            }
            
            self.calculateTotal()
            self.updateUI()
        })
        
    }
    
    func updateUI() {
        self.itemsLeftLabel.text = "Items: \(self.shoppingItems.count)"
        self.totalPriceLabel.text = "Total Price: £\(String(format: "%.2f", self.totalPrice!))"
        self.tableView.reloadData()
    }
    
    //MARK: Helper Functions
    
    func showMailError() {
        let sendMailErrorAlert = UIAlertController(title: "Could not send email", message: "We were unable to send your email", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func createError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
   
    
    func calculateTotal() {
        self.totalPrice = 0
        
        for item in boughtItems {
            //self.totalPrice = self.totalPrice + item.price
            self.totalPrice = self.totalPrice + (item.price * Float(item.quantity)!)
        }
        for item in shoppingItems {
            //self.totalPrice = self.totalPrice + item.price
            self.totalPrice = self.totalPrice + (item.price * Float(item.quantity)!)
        }
        
        self.totalPriceLabel.text = "Total Price: £\(String(format: "%.2f", self.totalPrice!))"
        
        shoppingList.totalPrice = self.totalPrice
        shoppingList.totalItems = self.boughtItems.count + self.shoppingItems.count
        
        shoppingList.updateItemInBackground(shoppingList: shoppingList) { (error) in
            if error != nil {
                createAlert(title: "Error updating shopping list", message: "")
            }
        }
    }
    
    func titleViewForTable(titleText: String) -> UIView {
    
        let view = UIView()
        view.backgroundColor = UIColor.darkGray
        let titleLabel = UILabel(frame: CGRect(x: 10, y: 5, width: 200, height: 20))
        titleLabel.text = titleText
        titleLabel.textColor = .white
        view.addSubview(titleLabel)
        return view
    }
    
    
    //MARK: MAIL COMPOSER DELEGATES
    
    func configureMailController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        firebase.child(kSUPPLIEREMAIL).child(FUser.currentId()).child("SupplierEmail").observe(.value, with: {
            snapshot in
            if snapshot.exists() {
                let toEmail = snapshot.value
                mailComposerVC.setToRecipients(["\(toEmail as! String)"])
                mailComposerVC.setSubject("New EDM Pro Purchase Order")
                
            } else {
                self.showMailError()
            }
        })
        return mailComposerVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    func getDataForEmailBody() -> String {
        
        var res = ""
        
        for item in shoppingItems {
            res = "\(res)\(item.name) - \("£\(String(format: "%.2f", item.price))")\n\(item.info) - \(item.quantity)\n\n"
        }
        
        return res
    }
    
    //MARK: SwipeTableViewCell Delegate Functions
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {

        var item: ShoppingItem!

        if indexPath.section == 0 {

            item = self.shoppingItems[indexPath.row]
        } else {

            item = self.boughtItems[indexPath.row]
        }

        if orientation == .left {
            guard isSwipeRightEnabled else { return nil }

            let buyItem = SwipeAction(style: .default, title: nil) { action, indexPath in

                item.isBought = !item.isBought
                item.updateItemInBackground(shoppingItem: item, completion: { (error) in

                    if error != nil {
                        createAlert(title: "Error", message: "\(String(describing: error?.localizedDescription))")
                        return
                    }
                })

                if indexPath.section == 0 {

                    self.shoppingItems.remove(at: indexPath.row)
                    self.boughtItems.append(item)
                } else {

                    self.boughtItems.remove(at: indexPath.row)
                    self.shoppingItems.append(item)
                }

                tableView.reloadData()
            }

            buyItem.accessibilityLabel = item.isBought ? "Save" : "Return"

            let descriptor: ActionDescriptor = item.isBought ? .returnPurchase : .save

            configure(action: buyItem, with: descriptor)


            return [buyItem]
        } else {

            let delete = SwipeAction(style: .destructive, title: nil) { action, indexPath in


                if indexPath.section == 0 {

                    self.shoppingItems.remove(at: indexPath.row)
                } else {

                    self.boughtItems.remove(at: indexPath.row)
                }

                item.deleteItemInBackground(shoppingItem: item)

                action.fulfill(with: .delete)
                self.tableView.reloadData()

            }


            configure(action: delete, with: .trash)

            return [delete]

        }


    }

    func configure(action: SwipeAction, with descriptor: ActionDescriptor) {
        action.title = descriptor.title()
        action.image = descriptor.image()
        action.backgroundColor = descriptor.colour
    }

    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {

        var options = SwipeTableOptions()
        options.transitionStyle = defaultOptions.transitionStyle
        options.buttonSpacing = 11
        return options

    }
    
    //MYPRODUCTSVIEWCONTROLLER DELEGATE
    
    func didChooseItem(productItem: ProductItem) {
        
        let shoppingItem = ShoppingItem(productItem: productItem)
        shoppingItem.shoppingListId = shoppingList.id
        shoppingItem.saveItemInBackground(shoppingItem: shoppingItem) { (error) in
            if error != nil {
                createAlert(title: "Error Selecting Item", message: "")
            }
        }
        
    }
}
