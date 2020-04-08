//
//  UIViewControllerExtension.swift
//  OnTheMap
//
//  Created by Spencer Steggell on 3/10/20.
//  Copyright © 2020 Spencer Steggell. All rights reserved.
//

//    Extention to add to all controllers when the LOGOUT button is tapped.
import UIKit

extension UIViewController {
    
    @IBAction func logoutTapped (_ sender: UIBarButtonItem){
        
        UdacityClient.Auth.sessionId = ""
        self.dismiss(animated: true, completion: nil)
    }
}

