//
//  PurchaseOrdersViewController.swift
//  EDMPro
//
//  Created by Rob Prior on 21/06/2018.
//  Copyright © 2018 Rob Prior. All rights reserved.
//

import UIKit
import SwipeCellKit

class PurchaseOrdersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwipeTableViewCellDelegate, UISearchResultsUpdating {
    
    @IBOutlet var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var allLists:[ShoppingList] = []
    var filteredAllLists:[ShoppingList] = []
    
    var isSwipeRightEnabled = false
    var defaultOptions = SwipeTableOptions()
    
    var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLists()
        self.navigationItem.backBarButtonItem = nil
        self.navigationItem.hidesBackButton = true
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        tableView.tableHeaderView = searchController.searchBar
    }
    
    //MARK: TableView Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            
            return filteredAllLists.count
        }
        
        return allLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListTableViewCell
        
        let list: ShoppingList
        
        if searchController.isActive && searchController.searchBar.text != "" {
            list = filteredAllLists[indexPath.row]
        } else {
            list = allLists[indexPath.row]
        }
        
        
        
        cell.bindData(item: list)
        cell.delegate = self
        return cell
    }
    
    //MARK: TABLEVIEW DELEGATE
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "purchaseOrdersToNewOrderSeg", sender: indexPath)
    }
    
   
    //MARK: IBActions
    
    @IBAction func addBarButtonItemPressed(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Please enter your purchase order reference", message: "eg. 'Stock' or 'PO-12345'", preferredStyle: .alert)
        
        alertController.addTextField { (nameTextField) in
            
            nameTextField.placeholder = "Purchase Order Reference"
            nameTextField.autocapitalizationType = UITextAutocapitalizationType.words
            self.nameTextField = nameTextField
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            
            if self.nameTextField.text != "" {
                
                self.createShoppingList()
                
            } else {
                
                createAlert(title: "You must enter a Purchase Order Reference", message: "eg. 'Robs Order' or '12345'")
                
            }
            
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    //MARK: LoadLists
    
    func loadLists() {
        
        firebase.child(kSHOPPINGLIST).child(FUser.currentId()).observe(.value, with: {
            snapshot in
            
            self.allLists.removeAll()
            
            if snapshot.exists() {
                
                let sorted = ((snapshot.value as! NSDictionary).allValues as NSArray).sortedArray(using: [NSSortDescriptor(key: kDATE, ascending: false)])
                
                for list in sorted {
                    
                    let currentList = list as! NSDictionary
                    self.allLists.append(ShoppingList.init(dictionary: currentList))
                }
                
            } else {
                print("No Shapshot")
            }
            
            self.tableView.reloadData()
            
        })
        
    }
    
    //MARK: NAVIGATION
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "purchaseOrdersToNewOrderSeg" {
            let indexPath = sender as! IndexPath
            let shoppingList = allLists[indexPath.row]
            let vc = segue.destination as! NewOrderViewController
            vc.shoppingList = shoppingList
        }
    }
    
    //MARK: Helper Fuctions
    
    func createShoppingList() {
        let shoppingList = ShoppingList(_name: nameTextField.text!)
        
        shoppingList.saveItemInBackground(shoppingList: shoppingList) { (error) in
            
            if error != nil {
                
                createAlert(title: "Error creating new Purchase Order", message: "")
                
                return
            }
            
        }
    }
    
    //MARK: SWIPETABLEVIEWCELL DELEGATE FUNCTIONS
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        if orientation == .left {
            guard isSwipeRightEnabled else { return nil }
        }
        
        let delete = SwipeAction(style: .destructive, title: nil) { action, indexPath in
            
            var list: ShoppingList
            
            if self.searchController.isActive && self.searchController.searchBar.text != "" {
                list = self.filteredAllLists[indexPath.row]
                self.filteredAllLists.remove(at: indexPath.row)
            } else {
                list = self.allLists[indexPath.row]
                self.allLists.remove(at: indexPath.row)
            }
            
            
//            if self.allLists.count > 0 {
//                list = self.allLists[indexPath.row]
//                self.allLists.remove(at: indexPath.row)
//            } else {
//                list = self.allLists[indexPath.row]
//            }
            
            list.deleteItemInBackground(shoppingList: list)
            
            action.fulfill(with: .delete)
            self.tableView.reloadData()
            
        }
        configure(action: delete, with: .trash)
        return [delete]
        
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
    
    //MARK: SEARCH CONTROLLER
    
    func filterContentForSearchText(searchText: String, Scope: String = "All") {
        
        filteredAllLists = allLists.filter({ (item) -> Bool in
            return item.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)

    }
    
}
