//
//  ViewController.swift
//  Chatting
//
//  Created by Haamed Sultani on 2018-09-20.
//  Copyright © 2018 Sultani. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class LoginViewController: UIViewController {
    
    // MARK: - Variables
    var index = 0 // Used to keep track of the segmented control
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var myButton: UIButton!
    
    // MARK: - View Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        SVProgressHUD.setHapticsEnabled(true) // Give physical feedback to user when showing progress bar
        SVProgressHUD.setMinimumDismissTimeInterval(0.3) // Minimum time the progress spinner will show
        SVProgressHUD.setMaximumDismissTimeInterval(0.6) // Maximum time the progress spinner will show
        SVProgressHUD.setBackgroundColor(UIColor.init(red: 54, green: 168, blue: 125, alpha: 1))
        
        
        
        myButton.layer.cornerRadius = 5 // Set the roundness of button
        myButton.layer.borderWidth = 1 // Set the width of the border
        myButton.layer.borderColor = UIColor.white.cgColor // Set the color of the border
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]) // Set the placeholder text's color and string
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]) // Set the placeholder text's color and string
        emailTextField.textContentType = UITextContentType(rawValue: "") // Disable strong password suggestion from iOS
        passwordTextField.textContentType = UITextContentType(rawValue: "") // Disable strong password suggestion from iOS
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    // MARK: - Firebase Auth Methods
    // Use Firebase to register user
    func registerUser() {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) {
            (dataResult, error) in
            
            if error != nil { // There as an error
                print(error!)
                if let err = AuthErrorCode(rawValue: error!._code) {
                    switch err {
                    case .invalidEmail:
                        self.displayErrorMessage(errorMessage: "Invalid email.")
                    case .emailAlreadyInUse:
                        self.displayErrorMessage(errorMessage: "Email already in use.")
                    case .weakPassword:
                        self.displayErrorMessage(errorMessage: "Password is too weak.")
                    default:
                        self.displayErrorMessage(errorMessage: "Unknown error occurred.")
                    }
                }
                
            } else { // Successful request
                print("Successfully registered user")
                self.performSegue(withIdentifier: "showChatSegue", sender: self)
            }
            
            SVProgressHUD.showSuccess(withStatus: "Registered!") // Hide the progress spinner
        }
    }
    
    func loginUser() {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) {
            (user, error) in
            if error != nil {
                print(error!)
            } else {
                print("succesfully logged in")
                self.performSegue(withIdentifier: "showChatSegue", sender: self)
            }
            
            SVProgressHUD.showSuccess(withStatus: "Logged in!") // Hide the progress spinner

        }
    }
    
    // MARK: - UI Methods
    func displayErrorMessage(errorMessage: String) {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - IB Action Methods
    
    @IBAction func segmentSwitched(_ sender: Any) {
        index = segmentedControl.selectedSegmentIndex

        switch index {
        case 0:
            myButton.setTitle("Register", for: .normal)
        case 1:
            myButton.setTitle("Login", for: .normal)
        default:
            print("No selection")
        }
    }
    
    
    @IBAction func myButtonPressed(_ sender: Any) {
        SVProgressHUD.show() // Show the progress spinner
        
        if index == 0 {
            registerUser()
        } else if index == 1 {
            loginUser()
        }
    }
    
    
    // MARK: - Segue Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! ChatViewController
    }
}

