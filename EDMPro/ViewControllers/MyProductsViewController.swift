//
//  MyProductsViewController.swift
//  EDMPro
//
//  Created by Rob Prior on 16/07/2018.
//  Copyright © 2018 Rob Prior. All rights reserved.
//

import UIKit
import SwipeCellKit

protocol MyProductsViewControllerDelegate {
    
    func didChooseItem(productItem: ProductItem)
}

class MyProductsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate, UISearchResultsUpdating {

    
    var delegate: MyProductsViewControllerDelegate?
    @IBOutlet var tableView: UITableView!
    @IBOutlet var addButtonOutlet: UIButton!
    @IBOutlet var cancelButtonOutlet: UIButton!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var productItems: [ProductItem] = []
    var filteredProductItems: [ProductItem] = []
    
    var defaultOptions = SwipeTableOptions()
    var isSwipeRightEnabled = false
    
    var clicktoEdit = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelButtonOutlet.isHidden = clicktoEdit
        addButtonOutlet.isHidden = !clicktoEdit
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        tableView.tableHeaderView = searchController.searchBar

        loadProductItems()
    }
    
    //MARK: TABLEVIEWDATA SOURCE
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredProductItems.count
        }
        return productItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyProductsTableViewCell
        cell.delegate = self
        cell.selectedBackgroundView = createSelectedBackgroundView()
        
        var item: ProductItem
        
        if searchController.isActive && searchController.searchBar.text != "" {
            item = filteredProductItems[indexPath.row]
        } else {
            item = productItems[indexPath.row]
        }
        
        
        cell.bindDta(item: item)
        
        return cell
    }
    
    //MARK: TABLEVIEW DELEGATE FUNCTIONS
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        var item: ProductItem
        
        if searchController.isActive && searchController.searchBar.text != "" {
            item = filteredProductItems[indexPath.row]
        } else {
            item = productItems[indexPath.row]
        }
        
        if !clicktoEdit {
            self.delegate!.didChooseItem(productItem: item)
            
            self.dismiss(animated: true, completion: nil)
            
        } else {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddItemVC") as! AddItemViewController
            
            vc.productItem = item
            self.present(vc, animated: true, completion: nil)
        }
       
    }
    
    //MARK: IBACTIONS
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addBarButtonItemPressed(_ sender: Any) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddItemVC") as! AddItemViewController
        vc.addingToList = true
        self.present(vc, animated: true, completion: nil)
        
    }
    
    //MARK: LOAD PRODUCT ITEMS
    
    func loadProductItems() {
        
        firebase.child(kPRODUCTITEM).child(FUser.currentId()).observe(.value, with: {
            snapshot in
            
            self.productItems.removeAll()
            
            if snapshot.exists() {
                
                let allItems = (snapshot.value as! NSDictionary).allValues as Array
                for item in allItems {
                    let currentItem = ProductItem(dictionary: item as! NSDictionary)
                    self.productItems.append(currentItem)
                }
                
            } else {
                print("No snapshot 1")
            }
            self.tableView.reloadData()
        })
    }
    
    //MARK: SWIPETABLEVIEWCELL DELEGATE FUNCTIONS
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        if orientation == .left {
            guard isSwipeRightEnabled else { return nil }
        }
            
            let delete = SwipeAction(style: .destructive, title: nil) { action, indexPath in
                
                var item: ProductItem
                
                if self.searchController.isActive && self.searchController.searchBar.text != "" {
                    item = self.filteredProductItems[indexPath.row]
                    self.filteredProductItems.remove(at: indexPath.row)

                } else {
                  item = self.productItems[indexPath.row]
                    self.productItems.remove(at: indexPath.row)

                }
                
                item.deleteItemInBackground(productItem: item)
                
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
        //options.expansionStyle = orientation == .right = .destructive
        options.transitionStyle = defaultOptions.transitionStyle
        options.buttonSpacing = 11
        return options
        
    }
    
    //MARK: SEARCH CONTROLLER
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        filteredProductItems = productItems.filter({ (item) -> Bool in
            
            return item.name.lowercased().contains(searchText.lowercased())
            
        })
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }

}
