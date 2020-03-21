//
//  ViewController.swift
//  OnTheMap
//
//  Created by Spencer Steggell on 3/8/20.
//  Copyright © 2020 Spencer Steggell. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        
      emailTextField.text = ""
      passwordTextField.text = ""
        
    }

    
    @IBAction func loginTapped(_ sender: UIButton) {
        UdacityClient.login(email: emailTextField.text!, password: passwordTextField.text!) {(successful, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print(error.localizedDescription)
                    let errorAlert = UIAlertController(title: "Error", message: "The is error", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
                        return
                    }))
                    self.present(errorAlert, animated: true, completion: nil)
                }

                if !successful {
                    let invalidAccessAlert = UIAlertController(title: "Invalid Information", message: "Invalid email or password", preferredStyle: .alert)
                    invalidAccessAlert.addAction(UIAlertAction(title: "Re-enter", style: .default, handler: {_ in return}))
                    self.present(invalidAccessAlert, animated: true, completion: nil)
                } else {
                    let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                    //self.navigationController!.pushViewController(mapVC, animated: true)
                    self.present(mapVC, animated: true, completion: nil)
                    //self.performSegue(withIdentifier: "completeLogin", sender: nil)
                }
            }
        }
    }
}

