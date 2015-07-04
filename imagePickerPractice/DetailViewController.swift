//
//  DetailViewController.swift
//  imagePickerPractice
//
//  Created by Michael Nichols on 7/2/15.
//  Copyright (c) 2015 Michael Nichols. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    var memes: [Meme]?
    var meme: Meme!
    
    @IBOutlet weak var detailImageView: UIImageView!
    var detailImage: UIImage!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        detailImageView.image = detailImage
        
        // Setting memes array equal to AppDelegate memes data model
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
        tabBarController?.tabBar.hidden = true
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        
        // Hiding the status bar for the navigation bar
        return true
        
    }
    
    func removeMeme(memeArray: [Meme], meme: Meme) -> [Meme] {
        
        // A function to filter out a selected meme
        return memeArray.filter( {$0 !== meme})
        
    }
    
    @IBAction func deleteMeme(sender: UIBarButtonItem) {
        
        // Confirming deletion with alert view
        let alert = UIAlertController(title: "Confirm Deletion", message: "Permanently delete the meme?", preferredStyle: .Alert)
        let delete = UIAlertAction(title: "Delete", style: .Destructive, handler: {(_) in
            
            // Removing meme from meme array
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as! AppDelegate
            
            appDelegate.memes = self.removeMeme(appDelegate.memes, meme: self.meme)
            
            // Dismissing the view
            self.navigationController?.popToRootViewControllerAnimated(true)

        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: {(action) -> Void in})
        alert.addAction(delete)
        alert.addAction(cancel)
        
        presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    
}