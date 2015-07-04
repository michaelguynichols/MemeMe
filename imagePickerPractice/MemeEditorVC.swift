//
//  MemeEditorVC.swift
//  imagePickerPractice
//
//  Created by Michael Nichols on 6/28/15.
//  Copyright (c) 2015 Michael Nichols. All rights reserved.
//

import UIKit

class MemeEditorVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    // Boolean to control keyboard shifting the view only when bottomTextField is being edited.
    var bottomTextFieldBeganEditing = false
    var memedImage: UIImage?
    var meme: Meme?
    
    // Global keyboard height variable to account for different keyboard behavior
    var currentKeyboardHeight: CGFloat = 0
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Determining if the camera is available for the Image Picker Controller
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        // Subscribing to keyboard notifications
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unsubscribing to keyboard notificaitons
        unsubscribeToKeyboardNotifications()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disabling the shareButton until image is chosen
        shareButton.enabled = false
        
        // Setting text attributes of the top and bottom textfields
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 34)!,
            NSStrokeWidthAttributeName : 0,
        ]
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .Center
        bottomTextField.textAlignment = .Center
        
        // Initializing the text for the textfields
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        
        // Creating textfield delegates
        topTextField.delegate = self
        bottomTextField.delegate = self
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        
        // Hiding the status bar for the navigation bar
        return true
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        view.endEditing(true)
        
        // Every return will turn off bottomTextField boolean
        bottomTextFieldBeganEditing = false
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        // Only clear the textfield if the initial text is present
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
        
        // Turning on the bottomTextField boolean to allow the keyboard to shift the view
        if textField === bottomTextField {
            bottomTextFieldBeganEditing = true
        }
        
    }
    
    func getKeyboardHeight(notification: NSNotification) {
        
        // Getting the keyboard's height for shifting the view
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        currentKeyboardHeight = keyboardSize.CGRectValue().height
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        getKeyboardHeight(notification)
        
        // Only shift the view upward if the bottomTextField is selected
        if bottomTextFieldBeganEditing {
            view.frame.origin.y -= currentKeyboardHeight
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        // Only shift the view downward if the bottomTextField is selected
        if bottomTextFieldBeganEditing {
            view.frame.origin.y = 0
        }
        
        currentKeyboardHeight = 0
        
    }
    
    func subscribeToKeyboardNotifications() {
        
        // Subscribing to keyboard notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func unsubscribeToKeyboardNotifications() {
        
        // Unsubscribing from keyboard notifications
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
    }

    
    @IBAction func pickImageFromAlbum(sender: UIBarButtonItem) {
        
        // Creating the image picker controller, setting source, and presenting imagePicker ViewController
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func pickImageFromCamera(sender: UIBarButtonItem) {
        
        // Creating the image picker controller, setting source, and presenting imagePicker controller
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        // Dismissing the image picker controller
        dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        // Grabbing the image from the image picker if one was selected
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image.image = pickedImage
            dismissViewControllerAnimated(true, completion: nil)
            
            // Enabling shareButton
            shareButton.enabled = true
        }
        
    }
    
    func saveMeme() {
        
        // Creating Meme Object
        meme = Meme(top: topTextField.text!, bottom: bottomTextField.text!, original: image.image!, memed: memedImage!)
        
        // Adding the meme to the meme array in the appdelegate.swift file
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme!)
        
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide navbar and toolbar
        navBar.hidden = true
        toolBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Unhide navbar and toolbar
        navBar.hidden = false
        toolBar.hidden  = false
        
        return memeImage
        
    }
    
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        
        memedImage = generateMemedImage()
        
        
        let activityController = UIActivityViewController(activityItems: [memedImage!], applicationActivities: nil)
        
        presentViewController(activityController, animated: true, completion: nil)
        
        activityController.completionWithItemsHandler = {
            (activity, success, items, error) in
            
            if success {
                self.saveMeme()
            
                self.dismissViewControllerAnimated(false, completion: nil)
            }
        }
    }

    @IBAction func cancel(sender: UIBarButtonItem) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }

}

