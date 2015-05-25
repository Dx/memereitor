//
//  ViewController.swift
//  PickPic
//
//  Created by Dx on 03/04/15.
//  Copyright (c) 2015 Palmera. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imagePicker: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var theToolBar: UIToolbar!
    @IBOutlet weak var theTopToolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var instructionsLabel: UILabel!
    
    var isEditingText2 = false
    
    var xFromCenter : CGFloat!
    
    let initialTextTop = "TOP TEXT"
    let initialTextBottom = "BOTTOM TEXT"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shareButton.enabled = false
        
        firstTextField.delegate = self
        secondTextField.delegate = self
        
        firstTextField.text = initialTextTop
        secondTextField.text = initialTextBottom
        
        firstTextField.allowsEditingTextAttributes = true
        secondTextField.allowsEditingTextAttributes = true
        
        // Defines the attributes of texts used in labels
        let memeTextAttributes = [
            NSStrokeWidthAttributeName : -3.0,
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 42)!
        ]
        
        firstTextField.defaultTextAttributes = memeTextAttributes
        secondTextField.defaultTextAttributes = memeTextAttributes
        
        firstTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        secondTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        

        // Sets some gestures to be possible to drag the texts
        let gesture = UIPanGestureRecognizer(target: self, action: "dragged:")
        firstTextField.addGestureRecognizer(gesture)
        let gestureSecond = UIPanGestureRecognizer(target: self, action: "dragged:")
        secondTextField.addGestureRecognizer(gestureSecond)
        
        firstTextField.userInteractionEnabled = true
        secondTextField.userInteractionEnabled = true
        
        firstTextField.textAlignment = NSTextAlignment.Center
        secondTextField.textAlignment = NSTextAlignment.Center
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        // To avoid the events of showing and hidding the keyboard
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.unsubscribeFromKeyboardNotifications()
    }
    
    // Shows an activity view controller to share the meme
    @IBAction func shareClicked(sender: AnyObject) {
        let memedImage = generateMemedImage()
        
        let activity = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activity.completionWithItemsHandler = {
            (s: String!, ok: Bool, items: [AnyObject]!, err:NSError!) -> Void in
            self.save(memedImage)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        presentViewController(activity, animated: true, completion: nil)
    }
    
    @IBAction func startEditing(sender: AnyObject) {
        if (firstTextField.text == initialTextTop) {
            firstTextField.text = ""
        }
        isEditingText2 = false
    }
    
    @IBAction func startEditingText2(sender: AnyObject) {
        if (secondTextField.text == initialTextBottom) {
            secondTextField.text = ""
        }
        isEditingText2 = true
    }
    
    // Pick from gallery
    @IBAction func pickAnImage(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    // Pick from camera
    @IBAction func pickFromCamera(sender: AnyObject) {
        let cameraController = UIImagePickerController()
        cameraController.delegate = self
        cameraController.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(cameraController, animated: true, completion: nil)
        
    }
    
    // Closes the view on cancel
    @IBAction func clickOnCancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // This function move the labels where they are dragged
    func dragged(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translationInView(self.view)
        let label = gesture.view!
        
        xFromCenter = translation.x
        
        //absolute value, to always positive value so the label isn't turned upside down when moved to the left (left is negative on any axis). 1 divided by negative will give upside down result when used for stretch
        var scaleValue = min(95/abs(xFromCenter), 1.2)
        
        label.center = CGPoint(x: label.center.x + translation.x, y: label.center.y + translation.y)
        
        gesture.setTranslation(CGPoint(x: 0, y: 0), inView: self.view)
        
        var rotation: CGAffineTransform = CGAffineTransformMakeRotation(xFromCenter/200)
        var scale: CGAffineTransform = CGAffineTransformScale(rotation, scaleValue, scaleValue)
        
        label.transform = scale
    }
    
    // The meme is saved as an object in the app delegate
    func save(memedImage: UIImage) {

        var meme = Meme()
        meme.firstText = firstTextField.text
        meme.secondText = secondTextField.text
        meme.image = self.imagePicker.image!
        meme.memedImage = memedImage
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
    }
    
    // Gets the image of the picture plus both labels
    func generateMemedImage() -> UIImage{
        
        self.hideElementsNotDesiredInMeme(true)

        // Take the snapshot
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.hideElementsNotDesiredInMeme(false)
        
        return memedImage
    }
    
    // This elements gets hidden when the snapshot of the meme is taken
    func hideElementsNotDesiredInMeme(hide: Bool) {
        theToolBar.hidden = hide
        theTopToolBar.hidden = hide
        instructionsLabel.hidden = hide
    }
    
    // Take the image from the picker controller
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imagePicker.image = image
            shareButton.enabled = true
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // When the keyboard receives the return, it closes the keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func subscribeToKeyboardNotifications() {
                
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)

    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)

        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // Moves the view to see the text 2
    func keyboardWillShow(sender: NSNotification) {
        if (isEditingText2)
        {
            self.view.frame.origin.y -= getKeyboardHeight(sender)
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        if (isEditingText2)
        {
            self.view.frame.origin.y += getKeyboardHeight(sender)
        }
    }
    
    func getKeyboardHeight(sender: NSNotification) -> CGFloat {
        let userInfo = sender.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
}

