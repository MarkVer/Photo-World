//
//  CameraViewController.swift
//  MarkJai
//
//  Created by Mark Verwoerd on 16/02/16.
//  Copyright © 2016 Mark.Jai. All rights reserved.
//

import UIKit

// MARK: - Class
class AlbumDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var albumFiles =  [PFObject]()
    var parseObject: PFObject?
    
    // MARK: - Initializers
    // MARK: - Instance
    
    // MARK: - Outlets
    @IBOutlet var albumNameLabel: UILabel!
    @IBOutlet var albumLocationLabel: UILabel!
    @IBOutlet var albumDescriptionLabel: UITextView!
   
    @IBOutlet var albumDateLabel: UILabel!
    @IBOutlet var albumPhotoView: PFImageView!


    // MARK: - Actions

    @IBAction func returnToMapLabel(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    



    // MARK: - Function/Methods

    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Disable the user to edit the Textview
        albumDescriptionLabel.editable  = false
      
        
        albumNameLabel.text  = parseObject!.valueForKey("photoName") as? String
        albumLocationLabel.text  = parseObject!.valueForKey("adressLabelString") as? String
        albumDescriptionLabel.text  = parseObject!.valueForKey("photoDescription") as? String
        albumDateLabel.text  = parseObject!.valueForKey("dateFormatter") as? String


        albumPhotoView.file  = parseObject!.valueForKey("imageFile") as? PFFile
        albumPhotoView.loadInBackground()
    }
    

    
    // Start at the top of the TextView
    override func viewDidLayoutSubviews() {
        albumDescriptionLabel.setContentOffset(CGPointZero, animated: false)
    }
    
}


