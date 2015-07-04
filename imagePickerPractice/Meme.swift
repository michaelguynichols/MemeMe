//
//  Meme.swift
//  imagePickerPractice
//
//  Created by Michael Nichols on 6/29/15.
//  Copyright (c) 2015 Michael Nichols. All rights reserved.
//

import Foundation
import UIKit

class Meme {
    var topText: String
    var bottomText: String
    var originalImage: UIImage
    var memeImage: UIImage
    
    init(top: String, bottom: String, original: UIImage, memed: UIImage) {
        self.topText = top
        self.bottomText = bottom
        self.originalImage = original
        self.memeImage = memed
    }
}