//
//  FUser.swift
//  EDMPro
//
//  Created by Rob Prior on 25/08/2018.
//  Copyright © 2018 Rob Prior. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class FUser {
    
    let objectId: String
    let createdAt: Date
    var email: String
    var firstName: String
    var companyName: String
    
    init(_objectId: String, _createdAt: Date, _email: String, _firstName: String, _companyName: String) {
        
        objectId = _objectId
        createdAt = _createdAt
        email = _email
        firstName = _firstName
        companyName = _companyName
        
    }
    
    init(_dictionary: NSDictionary) {
        objectId = _dictionary[kOBJECTID] as! String
        createdAt = dateFormatter().date(from: _dictionary[kCREATEDAT] as! String)!
        email = _dictionary[kEMAIL] as! String
        firstName = _dictionary[kFIRSTNAME] as! String
        companyName = _dictionary[kCOMPANYNAME] as! String
    }
    
    //MARK: Returning current user func
    
    class func currentId() -> String {
        
        return Auth.auth().currentUser!.uid
    }
    
    class func currentUser() -> FUser? {
        
        if Auth.auth().currentUser != nil {
            if let dictionary = userDefaults.object(forKey: kCURRENTUSER) {
                return FUser.init(_dictionary: dictionary as! NSDictionary)
            }
        }
        return nil
    }
    
    //MARK: Login and register function
    
    class func loginUserWith(email: String, password: String, completion: @escaping (_ error: Error?) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (firUser, error) in
            
            if error != nil {
                completion(error)
                
                return
            }
            
            fetchUser(userId: firUser!.user.uid, completion: { (success) in
                if success {
                    print("user loaded successfully")
                }
            })
            
            
            completion(error)
            
        })
        
    }
    
    class func registerUserWith(email: String, password: String, firstName: String, companyName: String, completion: @escaping (_ error: Error?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (firUser, error) in
            
            if error != nil {
                completion(error)
                return
            }
            
            let fUser = FUser(_objectId: firUser!.user.uid, _createdAt: Date(), _email: firUser!.user.email!, _firstName: firstName, _companyName: companyName)
            
            saveUserLocally(fUser: fUser)
            saveUserInBackground(fUser: fUser)
            completion(error)
        })
    }
    
    //MARK: Log Out Current User
    
    class func logOutcurrentUser(completion: @escaping (_ success: Bool) -> Void) {
        
        userDefaults.removeObject(forKey: kCURRENTUSER)
        userDefaults.synchronize()
        
        do {
            try Auth.auth().signOut()
            completion(true)
        } catch let error as NSError {
            completion(false)
            print("Could not log out \(error.localizedDescription)")
        }
        
    }

}


//MARK: Save User Functions

func saveUserInBackground(fUser: FUser) {
    
    let ref = firebase.child(kUSER).child(fUser.objectId)
    ref.setValue(userDictionaryFrom(user: fUser))
    
}

func saveUserLocally(fUser: FUser) {
    UserDefaults.standard.set(userDictionaryFrom(user: fUser), forKey: kCURRENTUSER)
    UserDefaults.standard.synchronize()
}


func userDictionaryFrom(user: FUser) -> NSDictionary {
    let createdAt = dateFormatter().string(from: user.createdAt)
    return NSDictionary(objects: [user.objectId, createdAt, user.email, user.firstName, user.companyName], forKeys: [kOBJECTID as NSCopying, kCREATEDAT as NSCopying, kEMAIL as NSCopying, kFIRSTNAME as NSCopying, kCOMPANYNAME as NSCopying])
}

func fetchUser(userId: String, completion: @escaping (_ success: Bool) -> Void) {
    firebase.child(kUSER).queryOrdered(byChild: kOBJECTID).queryEqual(toValue: userId).observe(.value, with: {
        snapshot in
        
        if snapshot.exists() {
            
            let user = ((snapshot.value as! NSDictionary).allValues as Array).first! as! NSDictionary
            
            UserDefaults.standard.set(user, forKey: kCURRENTUSER)
            UserDefaults.standard.synchronize()
            
            completion(true)
        } else {
            completion(false)
        }
    })
}

func resetUserPassword(email: String) {
    
    Auth.auth().sendPasswordReset(withEmail: email) { (error) in
        if error != nil {
            createAlert(title: "Error Sending Password Reset Email", message: "")
        } else {
            createAlert(title: "Sent Password Reset Email", message: "")
        }
    }
    
}

func cleanUpFirebaseObservers() {
    
    firebase.child(kUSER).removeAllObservers()
    firebase.child(kSHOPPINGLIST).removeAllObservers()
    firebase.child(kSHOPPINGITEM).removeAllObservers()
    firebase.child(kPRODUCTITEM).removeAllObservers()
}




