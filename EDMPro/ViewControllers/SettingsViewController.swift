//
//  SettingsViewController.swift
//  EDMPro
//
//  Created by Rob Prior on 01/08/2018.
//  Copyright © 2018 Rob Prior. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var supplierNameTextField: UITextField!
    @IBOutlet var supplierEmailTextField: UITextField!
    @IBOutlet var signOutButtonOutlet: UIButton!
    @IBOutlet var saveButtonOutlet: UIButton!
    @IBOutlet var welcomeLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        loadSettings()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.supplierNameTextField.delegate = self
        self.supplierEmailTextField.delegate = self
        
        signOutButtonOutlet.layer.cornerRadius = 8
        signOutButtonOutlet.layer.borderWidth = 1
        signOutButtonOutlet.layer.borderColor = UIColor.init(red: 241/255, green: 95/255, blue: 38/255, alpha: 1).cgColor
        
        saveButtonOutlet.layer.cornerRadius = 8
        saveButtonOutlet.layer.borderWidth = 1
        saveButtonOutlet.layer.borderColor = UIColor.init(red: 241/255, green: 95/255, blue: 38/255, alpha: 1).cgColor
        
    }
    //MARK: IBAction
    @IBAction func signOutButtonPressed(_ sender: Any) {
        
        let actionSheet = UIAlertController(title: "", message: "Are you sure you would like to sign out?", preferredStyle: .actionSheet)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
            FUser.logOutcurrentUser { (success) in
                if success {
                    self.dismiss(animated: false, completion: nil)
                    cleanUpFirebaseObservers()
                    let loginView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogInView")
                    self.present(loginView, animated: true, completion: nil)
                }
            }
        }
        let noAction = UIAlertAction(title: "No", style: .destructive) { (UIAlertAction) in
            
        }
        actionSheet.addAction(yesAction)
        actionSheet.addAction(noAction)
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        let supplierName = supplierNameTextField.text
        let supplierEmail = supplierEmailTextField.text
        
        
        if let name = supplierNameTextField.text, let email = supplierEmailTextField.text, (name.count > 0 && email.count > 0) {
            let ref1 = firebase.child(kSUPPLIERNAME).child(FUser.currentId()).child("SupplierName")
            ref1.setValue(supplierName)
            let ref2 = firebase.child(kSUPPLIEREMAIL).child(FUser.currentId()).child("SupplierEmail")
            ref2.setValue(supplierEmail)
            
            createError(title: "Settings Saved", message: "")
        } else {
            createError(title: "Error Saving Supplier Information", message: "Please ensure that you have entered both a supplier name and email")
        }
    }
    
    func loadSettings() {
        
        firebase.child(kUSER).child(FUser.currentId()).child(kFIRSTNAME).observe(.value, with: {
            snapshot in
            if snapshot.exists() {
                self.welcomeLabel.text = "Hi, \(snapshot.value as? String ?? "Hey, welcome to EDM Pro")"
            } else {
                self.welcomeLabel.text = "Welcome back,"
            }
            
        })
        
            firebase.child(kSUPPLIERNAME).child(FUser.currentId()).child("SupplierName").observe(.value, with: {
                snapshot in
                if snapshot.exists() {
                    self.supplierNameTextField.placeholder = snapshot.value as? String
                } else {
                    print("No snapshot for supplier name")
                }
                
            })
            
            firebase.child(kSUPPLIEREMAIL).child(FUser.currentId()).child("SupplierEmail").observe(.value, with: {
                snapshot in
                if snapshot.exists() {
                    self.supplierEmailTextField.placeholder = snapshot.value as? String
                } else {
                    self.supplierEmailTextField.placeholder = "e.g. a.supplier@eel.co.uk"
                    print("No snapshot snapshot for supplier email")
                    
                }
            })
        }
    
    
    //MARK Keyboard Functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        supplierNameTextField.resignFirstResponder()
        supplierEmailTextField.resignFirstResponder()
        return (true)
    }
    
    //MARK: HELPER FUNCTIONS
    
    func createError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }



    
}

