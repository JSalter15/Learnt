//
//  CustomTableViewCell.swift
//  Learnt
//
//  Created by Joe Salter on 6/20/16.
//  Copyright © 2016 Joe Salter. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var profPic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var profPicImageView:UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profPicImageView = UIImageView(frame: CGRectMake(8, 8, 40, 40))
        profPicImageView!.layer.masksToBounds = true
        profPicImageView!.layer.cornerRadius = 6
        profPicImageView?.contentMode = .ScaleToFill
        self.addSubview(profPicImageView!)
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
