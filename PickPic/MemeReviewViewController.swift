//
//  MemeReviewViewController.swift
//  PickPic
//
//  Created by Dx on 19/05/15.
//  Copyright (c) 2015 Palmera. All rights reserved.
//

import UIKit

class MemeReviewViewController: UIViewController {

    @IBOutlet weak var memeImage: UIImageView!
    
    var meme: Meme?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        memeImage.image = meme!.memedImage as UIImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // The preview can be shared again
    @IBAction func shareClicked(sender: AnyObject) {
        let memedImage = meme!.memedImage as UIImage
        
        let activity = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activity.completionWithItemsHandler = {
            (s: String!, ok: Bool, items: [AnyObject]!, err:NSError!) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        presentViewController(activity, animated: true, completion: nil)
    }

}
