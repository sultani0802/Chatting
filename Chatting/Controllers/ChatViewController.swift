//
//  ChatViewController.swift
//  Chatting
//
//  Created by Haamed Sultani on 2018-09-20.
//  Copyright © 2018 Sultani. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import ChameleonFramework

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // MARK: - Variables
    let MESSAGE_DB: String = "Messages"
    
    var isKeyboardAppear = false // Keeps track of whether the keyboard is up
    var myHeight: CGFloat?
    var keyboardHeight: CGFloat = 0
    var messageArray: [Message] = [Message]()
    
    // MARK: - IB Outlets
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageBackgroundView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatTableView.delegate = self
        chatTableView.dataSource = self
        messageTextField.delegate = self
        heightConstraint.constant = 60
        
        self.navigationItem.setHidesBackButton(true, animated: true) // Hide the back button in the navigation bar
        chatTableView.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "chatCellReuseIdentifier")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        configureTableView()
        
        myHeight = self.view.frame.height
        retrieveMessage()
        
        chatTableView.separatorStyle = .none
        chatTableView.allowsSelection = false
        chatTableView.keyboardDismissMode = .onDrag
    }
    
    
    // MARK: - UI Methods
    func displayErrorMessage(errorMessage: String) {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Firebase Methods
    func retrieveMessage(){
        let messageDB = Database.database().reference().child(MESSAGE_DB)
        
        // Listen for when a new message is added to the DB
        // This will also download the whole chat from the DB
        messageDB.observe(.childAdded) {
            (snapshot) in
            
            let result = snapshot.value as! Dictionary<String,String> // convert the data from the DB to the type we stored it as originally
            
            let messageBody = result["MessageBody"]!
            let sender = result["Sender"]!
            
            let message = Message(s: sender, m: messageBody) // Create a new Message object from the data we received
            self.messageArray.append(message) // Add the new Message object to our array
            self.configureTableView() // Make sure UI elements are properly configured
            self.chatTableView.reloadData()
            
        }
    }
    
    // MARK: - IB Actions
    @IBAction func logOutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch {
            displayErrorMessage(errorMessage: "There was an error logging out")
        }
    }
    
    
    @IBAction func sendPressed(_ sender: Any) {
        if messageTextField.text?.isEmpty == false{
            
            messageTextField.endEditing(true)
            messageTextField.isEnabled = false
            sendButton.isEnabled = false
            
            // Send message to Firebase and save it in our database
            let messageDB = Database.database().reference().child(MESSAGE_DB)
            let messageDict = ["Sender": Auth.auth().currentUser?.email,
                               "MessageBody": messageTextField.text!] //Get user's email and the message they want to send
            
            // Creates a custom random key for our message so that our message can be saved in the database under their own unique identifier
            messageDB.childByAutoId().setValue(messageDict) {
                (error, reference) in
                if error != nil {
                    print(error)
                } else {
                    self.messageTextField.isEnabled = true
                    self.sendButton.isEnabled = true
                    self.messageTextField.text = ""
                }
            }
        }
        
    }
    
    // MARK: - Table View methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCellReuseIdentifier", for: indexPath) as! ChatTableViewCell
        
        cell.messageLabel.text = messageArray[indexPath.row].messageBody
        cell.usernameLabel.text = messageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "egg")
        
        if cell.usernameLabel.text == Auth.auth().currentUser?.email as String!{
            cell.avatarImageView.backgroundColor = UIColor.flatSkyBlue()
            cell.messageBackgroundView.backgroundColor = UIColor.flatSkyBlue()
        } else {
            cell.avatarImageView.backgroundColor = UIColor.flatGray()
            cell.messageBackgroundView.backgroundColor = UIColor.flatGray()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        messageTextField.endEditing(true)
    }
    
    func configureTableView() {
        chatTableView.rowHeight = UITableView.automaticDimension // Rezise the message cell depending on the contents
        chatTableView.estimatedRowHeight = 82 // Default size of each message
    }
    
    
    // MARK: - Keyboard Delegate Methods
    // This method adjusts the view to make room for the keyboard
    @objc func keyboardWillShow(notification: NSNotification) {
        if !isKeyboardAppear {
            if let userInfo = notification.userInfo{
                let keyboardFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
                if self.view.frame.origin.y == 0 {
                    self.view.translatesAutoresizingMaskIntoConstraints = true
                    
                    var screenHeight: CGFloat {
                        return UIScreen.main.bounds.height
                    }
                    // x: 812
                    // 8: 667
                    if screenHeight == 812 {
                        UIView.animate(withDuration: 0.5, animations: {
                            self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height - keyboardFrame.height - 58)
                            self.view.layoutIfNeeded()
                            print(keyboardFrame.height)

                        })
                        
                    } else {
                        UIView.animate(withDuration: 0.5, animations: {
                            
                            self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height - keyboardFrame.height)
                            self.view.layoutIfNeeded()
                        })
                    }
                }
                
                self.keyboardHeight = keyboardFrame.height
            }
            isKeyboardAppear = true
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if isKeyboardAppear {
            if let userInfo = notification.userInfo{
                let keyboardFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
                if self.view.frame.origin.y == 0 {
                    self.view.translatesAutoresizingMaskIntoConstraints = true
                    
                    var screenHeight: CGFloat {
                        return UIScreen.main.bounds.height
                    }
                    // x: 812
                    // 8: 667
                    if screenHeight == 812 {
                        UIView.animate(withDuration: 0.5, animations: {
                            self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width, height: self.myHeight!)
                            self.view.layoutIfNeeded()
                            print(keyboardFrame.height)

                        })
                        
                    } else {
                        UIView.animate(withDuration: 0.5, animations: {
                            
                            self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width, height: self.myHeight!)
                            self.view.layoutIfNeeded()
                        })
                    }
                }
            }
            isKeyboardAppear = false
        }
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}
