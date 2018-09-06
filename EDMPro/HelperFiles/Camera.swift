//
//  Camera.swift
//  EDMPro
//
//  Created by Rob Prior on 13/07/2018.
//  Copyright © 2018 Rob Prior. All rights reserved.
//

import Foundation
import MobileCoreServices
import UIKit

class Camera {
    
    var delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate
    init(delegate_: UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
        
        delegate = delegate_
    }
    
    func PresentPhotoLibrary(target: UIViewController, canEdit: Bool) {
        
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) && !UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            return
        }
        let type = kUTTypeImage as String
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
            
            if let availableTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) {
                if (availableTypes as NSArray).contains(type) {
                    imagePicker.mediaTypes = [type]
                    imagePicker.allowsEditing = canEdit
                }
            }
        } else if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePicker.sourceType = .savedPhotosAlbum
            if let availableTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum) {
                if (availableTypes as NSArray).contains(type) {
                    imagePicker.mediaTypes = [type]
                }
            }
        } else {
          return
        }
        imagePicker.allowsEditing = canEdit
        imagePicker.delegate = delegate
        target.present(imagePicker, animated: true, completion: nil)
        return
    }
    
    func PresentPhotoCamera(target: UIViewController, canEdit: Bool) {
     
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            return
        }
        
        let type1 = kUTTypeImage as String
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            if let availableTypes = UIImagePickerController.availableMediaTypes(for: .camera) {
                if (availableTypes as NSArray).contains(type1) {
                    imagePicker.mediaTypes = [type1]
                    imagePicker.sourceType = .camera
                }
            }
            if UIImagePickerController.isCameraDeviceAvailable(.rear) {
                imagePicker.cameraDevice = .rear
            }
            else if UIImagePickerController.isCameraDeviceAvailable(.front) {
                imagePicker.cameraDevice = .front
            }
        } else {
            createAlert(title: "Camera Error", message: "The camera is not currently available")
            return
        }
        
        imagePicker.allowsEditing = canEdit
        imagePicker.showsCameraControls = true
        imagePicker.delegate = delegate
        target.present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    
}

