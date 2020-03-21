//
//  UIViewControllerExtension.swift
//  OnTheMap
//
//  Created by Spencer Steggell on 3/10/20.
//  Copyright © 2020 Spencer Steggell. All rights reserved.
//

import UIKit

extension UIViewController {
    
    @IBAction func logoutTapped (_ sender: UIBarButtonItem){
        
        self.dismiss(animated: true, completion: nil)
    }
}
