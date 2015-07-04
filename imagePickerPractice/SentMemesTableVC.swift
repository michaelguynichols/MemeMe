//
//  SentMemesTableVC.swift
//  MemeMe
//
//  Created by Michael Nichols on 6/30/15.
//  Copyright (c) 2015 Michael Nichols. All rights reserved.
//

import Foundation
import UIKit

class SentMemesTableVC: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    var memes: [Meme]?
    var detailImageView: UIImage?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // Setting memes array equal to AppDelegate memes data model
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
        // Ensuring data reloads when view appears
        tableView!.reloadData()
        
        tabBarController?.tabBar.hidden = false
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        
        // Hiding the status bar for the navigation bar
        return true
        
    }
    
   override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Number of rows in table view
        return memes!.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Deqeueing cell
        let cell = tableView.dequeueReusableCellWithIdentifier("TableViewItem") as! UITableViewCell
        
        // Variable to get current Meme in array
        var chosenMeme = memes![indexPath.row]
        
        // Get text description
        var top = chosenMeme.topText
        var bottom = chosenMeme.bottomText
        
        // Set cell image to current Meme in array
        cell.textLabel?.text = "\(top) \(bottom)"
        cell.imageView?.image = chosenMeme.memeImage
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Creating detail view controller to push
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        
        
        // Grabbing selected meme
        var meme = memes![indexPath.row]
        
        detailController.meme = meme
        
        // Grabbing current memed image
        detailImageView = memes![indexPath.row].memeImage
        
        detailController.detailImage = detailImageView
        
        // Pushing to the detail view
        navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Segue to the Meme Editor
        if segue.identifier == "MemeEditorSegueTV" {
            let memeEditorController = segue.destinationViewController as! MemeEditorVC
        }
        
    }
    
    @IBAction func addMeme(sender: UIBarButtonItem) {
        
        // Sending to Meme Editor with segue
        performSegueWithIdentifier("MemeEditorSegueTV", sender: self)
        
    }

    
    
}