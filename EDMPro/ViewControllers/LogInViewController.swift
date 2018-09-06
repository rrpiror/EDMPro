//
//  LogInViewController.swift
//  EDMPro
//
//  Created by Rob Prior on 22/08/2018.
//  Copyright © 2018 Rob Prior. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
       
    }

    
    //MARK: IB ACTIONS
    
    @IBAction func logInButtonPressed(_ sender: Any) {
        
        if emailTextField.text != "" && passwordTextField.text != "" {
            
            FUser.loginUserWith(email: emailTextField.text!, password: passwordTextField.text!, completion: { (error) in
                if error != nil {
                    createAlert(title: "Error Logging In", message: "")
                    return
                }
                self.emailTextField.text = nil
                self.passwordTextField.text = nil
                self.view.endEditing(true)
                
                self.goToApp()
            })
        }
    }
    
    @IBAction func forgotPasswordPressed(_ sender: Any) {
        
        if emailTextField.text != "" {
            resetUserPassword(email: emailTextField.text!)
        } else {
            
            createAlert(title: "Error", message: "Please enter an email in the email section above")
        }
    }
    
    //Go To Apps
    
    func goToApp() {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainView") as! UITabBarController
        
        vc.selectedIndex = 0
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func logInToRegisterButtonPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "LogInToRegisterSegue", sender: self)
    }
    

    //MARK: KEYBOARD DELEGATE
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return (true)
    }
    
    //MARK: Helper Functions

    func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
}
