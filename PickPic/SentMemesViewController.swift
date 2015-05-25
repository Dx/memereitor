//
//  SentMemesViewController.swift
//  PickPic
//
//  Created by Dx on 09/05/15.
//  Copyright (c) 2015 Palmera. All rights reserved.
//

import UIKit

class SentMemesViewController : UITableViewController {
    
    let reuseIdentifier = "cell";
    var memes: [Meme]!

    @IBOutlet var myTableView: UITableView!
    
    override func viewDidLoad() {
        var nib = UINib(nibName: "MemeCell", bundle: nil)
        myTableView.registerNib(nib, forCellReuseIdentifier: reuseIdentifier)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate

        // Get the memes from app delegate
        memes = appDelegate.memes
        
        if memes.count < 1
        {
            self.performSegueWithIdentifier("showEditorFromTable", sender: self)
        }
        myTableView.reloadData()
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MemeCell
        let memeElement = memes[indexPath.row]
        
        // Set the image
        cell.memeImage.image = memeElement.memedImage as UIImage
        cell.title.text = memeElement.firstText
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        var memeReview = storyboard!.instantiateViewControllerWithIdentifier("MemeReview") as! MemeReviewViewController
        memeReview.meme = memes[indexPath.row]
        
        self.navigationController?.pushViewController(memeReview, animated: true)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
}
