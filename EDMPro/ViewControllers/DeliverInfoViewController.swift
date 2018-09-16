//
//  DeliverInfoViewController.swift
//  EDMPro
//
//  Created by BluePine on 9/6/18.
//  Copyright © 2018 Rob Prior. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class DeliverInfoViewController: UIViewController {
    
    @IBOutlet var date_picker: UIDatePicker!
    
    @IBOutlet var address_editor: UITextView!
    @IBOutlet var info_editor: UITextView!
    
    var completion_handler : (( _ address: String, _ date: String, _ extra: String) -> Void)!
    
    static func show( navvc: UINavigationController, completion: @escaping ( _ address: String, _ date: String, _ extra: String) -> Void) {
        
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc: DeliverInfoViewController = sb.instantiateViewController(withIdentifier: "DeliverInfoViewController") as! DeliverInfoViewController
        vc.completion_handler = completion
        navvc.pushViewController(vc, animated: true)

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        date_picker.minimumDate = Date()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.shared.enable = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = false

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        address_editor.becomeFirstResponder()
    }

    @IBAction func backButtonSelected(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneButtonSelected(_ sender: Any) {
        
        if address_editor.text.count == 0 {
            let sendMailErrorAlert = UIAlertController(title: "", message: "Please input address", preferredStyle: .alert)
            let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
            sendMailErrorAlert.addAction(dismiss)
            self.present(sendMailErrorAlert, animated: true, completion: nil)

            return
        }
        
        if completion_handler != nil {
            
            let df = DateFormatter()
            df.dateFormat = "dd-MM-yyyy"
            
            completion_handler(address_editor.text, df.string(from: date_picker.date), info_editor.text)
        }
    }
    
}
