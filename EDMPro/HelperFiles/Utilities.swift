//
//  Utilities.swift
//  EDMPro
//
//  Created by Rob Prior on 23/06/2018.
//  Copyright © 2018 Rob Prior. All rights reserved.
//

import Foundation
import UIKit

private let dateFormat = "yyyyMMddHHmmss"

func dateFormatter() -> DateFormatter {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat

    return dateFormatter
}

func createAlert(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    //...
    var rootViewController = UIApplication.shared.keyWindow?.rootViewController
    if let navigationController = rootViewController as? UINavigationController {
        rootViewController = navigationController.viewControllers.first
    }
    if let tabBarController = rootViewController as? UITabBarController {
        rootViewController = tabBarController.selectedViewController
    }
    
    let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alertController.addAction(action)
    
    rootViewController?.present(alertController, animated: true, completion: nil)
    
}

func maskRoundedImage(image: UIImage, radius: Float) -> UIImage {
    
    let imageView: UIImageView = UIImageView(image: image)
    var layer: CALayer = CALayer()
    layer = imageView.layer
    
    layer.masksToBounds = true
    layer.cornerRadius = CGFloat(radius)
    
    UIGraphicsBeginImageContext(imageView.bounds.size)
    layer.render(in: UIGraphicsGetCurrentContext()!)
    let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return roundedImage!
}

func imageFromData(pictureData: String, withBlock: (_ image: UIImage?) -> Void) {
    
    var image: UIImage?
    
    let decodedData = NSData(base64Encoded: pictureData, options: NSData.Base64DecodingOptions(rawValue: 0))
    
    
    image = UIImage(data: decodedData! as Data)
    
    withBlock(image)
    
}

//func imageFromData(pictureData: String, withBlock: (_ image: UIImage?) -> Void) {
//
//    var image: UIImage?
//    let decodedData = NSData(base64Encoded: pictureData, options: NSData.Base64DecodingOptions(rawValue: 0))
//    image = UIImage(data: decodedData! as Data)
//    withBlock(image)
//}



//extension UIImage {
//    var isPortrait:  Bool    { return size.height > size.width }
//    var isLandscape: Bool   { return size.width > size.height }
//    var breadth:     CGFloat    { return min(size.width, size.height) }
//    var breadthSize: CGSize { return CGSize(width: breadth, height: breadth) }
//    var breadthRect: CGRect { return CGRect(origin: .zero, size: breadthSize) }
//
//    var circleMasked: UIImage? {
//        UIGraphicsBeginImageContextWithOptions(breadthSize, false, scale)
//        defer { UIGraphicsEndImageContext() }
//        guard let cgImage = cgImage?.cropping(to: CGRect(origin: CGPoint(x: isLandscape ? floor((size.width - size.height) / 2) : 0, y: isPortrait  ? floor((size.height - size.width) / 2) : 0), size: breadthSize)) else { return nil }
//        UIBezierPath(ovalIn: breadthRect).addClip()
//        UIImage(cgImage: cgImage).draw(in: breadthRect)
//        return UIGraphicsGetImageFromCurrentImageContext()
//    }
//
//    func scaleImageToSize(newSize: CGSize) -> UIImage {
//        var scaledImageRect = CGRect.zero
//        let aspectWidth = newSize.width/size.width
//        let aspectHeight = newSize.height/size.height
//
//        let aspectRatio = max(aspectWidth, aspectHeight)
//
//        scaledImageRect.size.width = size.width * aspectRatio;
//        scaledImageRect.size.height = size.height * aspectRatio;
//        scaledImageRect.origin.x = (newSize.width - scaledImageRect.size.width) / 2.0;
//        scaledImageRect.origin.y = (newSize.height - scaledImageRect.size.height) / 2.0;
//
//        UIGraphicsBeginImageContext(newSize)
//        draw(in: scaledImageRect)
//        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return scaledImage!
//    }
//}

