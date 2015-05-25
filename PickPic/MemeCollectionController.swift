//
//  MemeCollectionController.swift
//  PickPic
//
//  Created by Dx on 18/05/15.
//  Copyright (c) 2015 Palmera. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"

class MemeCollectionController: UICollectionViewController {

    var memes: [Meme]!
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        
        // Get the memes from app delegate
        memes = appDelegate.memes
        
        myCollectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MemeCollectionCell
        let memeElement = memes[indexPath.row]
        
        // Set the image
        cell.memeImage.image = memeElement.memedImage as UIImage
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var memeReview = storyboard!.instantiateViewControllerWithIdentifier("MemeReview") as! MemeReviewViewController
        
        memeReview.meme = memes[indexPath.row]
        
        self.navigationController?.pushViewController(memeReview, animated: true)
    }
}
