//
//  SentMemesCollectionViewController.swift
//  imagePickerPractice
//
//  Created by Michael Nichols on 6/30/15.
//  Copyright (c) 2015 Michael Nichols. All rights reserved.
//

import Foundation
import UIKit

class SentMemesCollectionViewController: UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var memes: [Meme]!
    var detailImageView: UIImage?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Ensuring data reloads when view appears
        collectionView!.reloadData()
        
        // Setting memes array equal to AppDelegate memes data model
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
        // Hiding tab bar in pushed views
        tabBarController?.tabBar.hidden = false
        
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        
        
        // Hiding the status bar for the navigation bar
        return true
        
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // Number of items in collection view
        return memes.count
    
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // Deqeueing cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewItem", forIndexPath: indexPath) as! SentMemeCollectionViewCell
        
        // Variable to get current Meme in array
        var chosenMeme = memes[indexPath.row]
        
        // Set cell image to current Meme in array
        cell.collectionImageView?.image = chosenMeme.memeImage
   
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
     
        // Creating controller for the detail view to push
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        
        // Grabbing current meme
        var meme = memes![indexPath.row]
        
        detailController.meme = meme
        
        // Grabbing current memed image
        detailImageView = memes[indexPath.row].memeImage
        
        detailController.detailImage = detailImageView
  
        // Pushing to the detail view
        navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Segue to the Meme Editor
        if segue.identifier == "MemeEditorSegue" {
            let memeEditorController = segue.destinationViewController as! MemeEditorVC
        
        }
        
    }
    
    @IBAction func addMeme(sender: UIBarButtonItem) {
        
        // Sending to Meme Editor with segue
        performSegueWithIdentifier("MemeEditorSegue", sender: self)
        
    }
        
}