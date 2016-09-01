//
//  TableViewController.swift
//  MarkJai
//
//  Created by Juwendsley Felicia on 16-02-16.
//  Copyright © 2016 Mark.Jai. All rights reserved.
//

import UIKit
import Parse

// MARK: - Class

class TableViewController: UITableViewController {

    // Create ParseArray
    var parseFiles =  [PFObject]()

// MARK: - Properties
    


// MARK: - Initializers
    
    
// MARK: - Instance
    
    
// MARK: - Outlets
    
    
// MARK: - Actions
    
    // adding poptoroot
    //adding dismiss
    // going to info, jasper ging naar internet om iets toe te voegen
    
    
// MARK: - Function/Methods
   
    // Load the parse files
    func dataFromParse() {
        let query = PFQuery(className: "PhotoPin")
       // Order the photo's on date they createdAt
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?)-> Void in
            
            if error == nil {
                self.parseFiles = objects!
                print(self.parseFiles)
                print(self.parseFiles.count)
                self.tableView.reloadData()
                print("yes")
                
            } else {
                // Log details of the failure
                print("Error: \(error!)")
            }
        }
    }
    
    // Count the number of files in parse to see how many rows are needed
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return  parseFiles.count
        
        
    }
    
    
    
     // load the specific information in the cells
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
      
        let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCell") as! TableViewCell!
        let dataCell = parseFiles[indexPath.row]
        
       //cell.updateLabels()
        cell.nameFieldCell.text =   dataCell.valueForKey("photoName") as? String
        cell.locationLabelCell.text =  dataCell.valueForKey("adressLabelString") as? String
        cell.imageViewCell.file = dataCell.valueForKey("imageFile") as? PFFile
    
        cell.imageViewCell.loadInBackground()
        
        return cell
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
        let albumDetailVC = self.storyboard?.instantiateViewControllerWithIdentifier("AlbumDetailViewController") as! AlbumDetailViewController
        
        let myIndexPath = self.tableView.indexPathForSelectedRow?.row
        let myParseFiles = parseFiles[myIndexPath!]
        
        albumDetailVC.parseObject = myParseFiles
        self.navigationController!.pushViewController(albumDetailVC, animated: true)
        
    }
    

    
    override func viewDidLoad() {
        dataFromParse()
    }
}

