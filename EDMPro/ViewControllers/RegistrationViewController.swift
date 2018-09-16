//
//  RegistrationViewController.swift
//  EDMPro
//
//  Created by Rob Prior on 22/08/2018.
//  Copyright © 2018 Rob Prior. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var companyNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        companyNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self

    }
    
    //MARK: IB ACTIONS
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        
        if nameTextField.text == "" || companyNameTextField.text == "" || emailTextField.text == "" || passwordTextField.text == "" {
            createError(title: "Unable to Register", message: "Please ensure you fill in all the information")
            dismissKeyboard()
        } else {
            FUser.registerUserWith(email: emailTextField.text!, password: passwordTextField.text!, firstName: nameTextField.text!, companyName: companyNameTextField.text!, completion: { (error) in
                if error != nil {
                    self.createError(title: "Error Could Not Register", message: "")
                    return
                }
                self.goToApp()
            })
            dismissKeyboard()
        }
        
    }
    
    @IBAction func backToLogInButtonPressed(_ sender: Any) {
        //performSegue(withIdentifier: "RegisterToLogInSegue", sender: self)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: KEYBOARD DELEGATE
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        companyNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return (true)
    }
    
    //MARK: Helper Functions
    
    func createError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    func goToApp() {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainView") as! UITabBarController
        
        vc.selectedIndex = 0
        
        self.present(vc, animated: true, completion: nil)
    }
    
}
