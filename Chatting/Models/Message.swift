//
//  Message.swift
//  Chatting
//
//  Created by Haamed Sultani on 2018-09-20.
//  Copyright © 2018 Sultani. All rights reserved.
//

import Foundation

class Message {
    
    // MARK: - Variables
    var sender: String = ""
    var messageBody: String = ""
    
    init(s: String, m: String){
        sender = s
        messageBody = m
    }
}
