//
//  ViewController.swift
//  Chatting
//
//  Created by Haamed Sultani on 2018-09-20.
//  Copyright © 2018 Sultani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    // MARK: - IB Outlets
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var myButton: UIButton!
    
    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.title = "Welcome"
        
        myButton.layer.cornerRadius = 5 // Set the roundness of button
        myButton.layer.borderWidth = 1 // Set the width of the border
        myButton.layer.borderColor = UIColor.white.cgColor // Set the color of the border
        
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]) // Set the placeholder text's color and string
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]) // Set the placeholder text's color and string
    }

    
    // MARK: - My Methods
    
    
    
    // MARK: - IB Action Methods
    
    @IBAction func segmentSwitched(_ sender: Any) {
        let index = segmentedControl.selectedSegmentIndex
        
        switch index {
        case 0:
            myButton.setTitle("Register", for: .normal)
        case 1:
            myButton.setTitle("Login", for: .normal)
        default:
            print("No selection")
        }
        
    }
}

