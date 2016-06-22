//
//  HelpPopUpViewController.swift
//  Learnt
//
//  Created by Joe Salter on 6/22/16.
//  Copyright © 2016 Joe Salter. All rights reserved.
//

import UIKit

class HelpPopUpViewController: UIViewController {

    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var postButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.backgroundColor = UIColor.clearColor()
        textView.textColor = UIColor.whiteColor()
        
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        self.popUpView.layer.cornerRadius = 5
        self.popUpView.layer.shadowOpacity = 0.8
        self.popUpView.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        

        // Do any additional setup after loading the view.
    }

    func showInView(aView: UIView!, animated: Bool)
    {
        aView.addSubview(self.view)
        if animated {
            self.showAnimate()
        }
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
        self.view.alpha = 0.0;
        UIView.animateWithDuration(0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
        })
    }
    
    func removeAnimate()
    {
        UIView.animateWithDuration(0.25, animations: {
            self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.view.removeFromSuperview()
                }
        })
    }
    
    @IBAction func closeButtonTapped(sender: UIButton) {
        self.removeAnimate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
