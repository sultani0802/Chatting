//
//  ChatTableViewCell.swift
//  Chatting
//
//  Created by Haamed Sultani on 2018-09-20.
//  Copyright © 2018 Sultani. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    // MARK: - IB Outlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var messageBackgroundView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
