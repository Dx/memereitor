//
//  MemeCell.swift
//  PickPic
//
//  Created by Dx on 17/05/15.
//  Copyright (c) 2015 Palmera. All rights reserved.
//

import UIKit

class MemeCell: UITableViewCell {

    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
