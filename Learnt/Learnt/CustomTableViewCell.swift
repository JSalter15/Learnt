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
    @IBOutlet weak var favoriteHeart: UIButton!
    
    var profPicImageView:UIImageView?
    var isFavorited = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profPicImageView = UIImageView(frame: CGRectMake(8, 8, 50, 50))
        profPicImageView!.layer.masksToBounds = true
        profPicImageView!.layer.cornerRadius = 6
        profPicImageView?.contentMode = .ScaleToFill
        self.addSubview(profPicImageView!)
        
        // Initialization code
    }
    
    @IBAction func favoriteTapped(sender: UIButton) {
        print("Hi")
        if !isFavorited {
            isFavorited = true
            favoriteHeart.setImage(UIImage(named: "orangeHeart.png"), forState: .Normal)
            
            let user = UserController.sharedInstance.getLoggedInUser()
        }
        else {
            isFavorited = false
            favoriteHeart.setImage(UIImage(named: "grayHeart.png"), forState: .Normal)
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
