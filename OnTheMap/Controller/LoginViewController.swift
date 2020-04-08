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
    @IBOutlet weak var loginLoadingIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        
      emailTextField.text = ""
      passwordTextField.text = ""
        
    }
    
    func setWorkingAnimation(animate: Bool) {
    if animate
    {
        loginLoadingIndicator.startAnimating()
    }
    else {
        loginLoadingIndicator.stopAnimating()
    }
    }
    
//  Link to take you to Safari to Sign up
    @IBAction func signUpLink(_ sender: UIButton) {
        print("LAUNCH UDACITY SIGNUP")
        UIApplication.shared.open(UdacityClient.Endpoints.signUp.url , options: [:], completionHandler: nil)
        
    }
//    Function when the user types in their information and taps Login
    @IBAction func loginTapped(_ sender: UIButton) {
        self.setWorkingAnimation(animate: true)
        getLoginInfo()
    }
//  Pulls the information from the boxes and plugs into the login request
        func getLoginInfo() {
            UdacityClient.login(email: self.emailTextField.text ?? "" , password: self.passwordTextField.text ?? "", completion: self.handleLoginResponse(success:error:))
        }
        
        func handleLoginResponse(success: Bool, error: Error?) {
            if success {
                getUserName()
                self.setWorkingAnimation(animate: false)
                self.performSegue(withIdentifier: "completeLogin", sender: nil)
            }
            else {
                showLoginFailure(message: "Invalid Email or Password, Please Re-enter")
                print("Login Failed")
            }
            
        }
//    Used to get the name of the user, with this API it is randomly generated.
    func getUserName() -> Void {
        UdacityClient.getUserInfo(userKey: UdacityClient.Auth.userKey, completion: self.getUserNameHelper(success:error:))
        
    }
    
    func getUserNameHelper(success: Bool, error: Error?) {
        if success {
            print("First Name: \(UdacityClient.Auth.firstName), Last Name: \(UdacityClient.Auth.lastName)")
        } else {
            print("Unable to get name")
        }
        
    }
//    Login failure message.
    func showLoginFailure(message: String) {
         let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
         alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
         show(alertVC, sender: nil)
     }
}

//        UdacityClient.login(email: emailTextField.text!, password: passwordTextField.text!) {(successful, error) in
////            DispatchQueue.main.async {
//                self.setWorkingAnimation(animate: true)
//                if let error = error {
//                    print(error.localizedDescription)
//                    let errorAlert = UIAlertController(title: "Error", message: "The is error", preferredStyle: .alert)
//                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
//                        return
//                    }))
//                    self.present(errorAlert, animated: true, completion: nil)
//                }
//
//                if !successful {
//                    let invalidAccessAlert = UIAlertController(title: "Invalid Information", message: "Invalid email or password", preferredStyle: .alert)
//                    invalidAccessAlert.addAction(UIAlertAction(title: "Re-enter", style: .default, handler: {_ in return}))
//                    self.present(invalidAccessAlert, animated: true, completion: nil)
//                    self.setWorkingAnimation(animate: false)
//                } else {
//                    let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
//                    //self.navigationController!.pushViewController(mapVC, animated: true)
//                    self.present(mapVC, animated: true, completion: nil)
//                    //self.performSegue(withIdentifier: "completeLogin", sender: nil)
//
//            }
//        }
//    }

