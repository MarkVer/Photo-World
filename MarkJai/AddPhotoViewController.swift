//
//  ListPhotoViewController.swift
//  MarkJai
//
//  Created by Mark Verwoerd on 16/02/16.
//  Copyright © 2016 Mark.Jai. All rights reserved.
//

import UIKit
import Parse
import CoreLocation

class AddPhotoViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {

// MARK: - Properties

  
// MARK: - Initializers
    

    
// MARK: - Instance
    
    var image: UIImage?
    
    // Creating the instance of "NSDateFormatter" to display it on this viewController
    let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .NoStyle
        return formatter
    }()
    
    
    var shortDate: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.stringFromDate(NSDate())
    }
    
    
// MARK: - Outlets
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var descriptionField: UITextView!
    @IBOutlet var imageView: PFImageView!
    @IBOutlet var saveToParseOutlet: UIButton!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!


    

    
  
// MARK: - Actions
    
    @IBAction func AddPhotoLabel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancelButtonToMap(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
 //  Checks if background is tapped. When tapped dismiss the keyboard
    @IBAction func backgroundTapped(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // Saving the Object to Parse
    @IBAction func saveToParse(sender: AnyObject) {
        
    // http://shrikar.com/creating-a-post-and-uploading-image-to-parse/
    
       
        
    // creating a constant to store the image in an PFFile
    // create a constant to store the nameField input
        let photoName = nameField.text
        
    // create a constant to store the descriptionField input
        let photoDescription = descriptionField.text
        
    // Create a constant to store the dateLabel input
        let dateLabel = NSDate()
        
    // Create a constant to store the latitude and longtitude
        let manager = CLLocationManager()
        let loc =  manager.location!.coordinate
        let locationCoord = PFGeoPoint(latitude:loc.latitude,longitude:loc.longitude)
        
    // Create a constant to store the streetname, cityname, zipcode and country
        let addressMakers = locationLabel.text!
        
    // connect to the classname in parse
        let itemObject = PFObject(className: "PhotoPin")
        
    // connect the input to the itemObject
        itemObject["photoName"] = photoName
        itemObject["photoDescription"] = photoDescription
        itemObject["dateLabel"] = dateLabel
//        itemObject.setObject(pimageFile!, forKey: "photoFile")
        itemObject["adressLabelString"] = addressMakers
        itemObject["locationLabel"] = locationCoord
        itemObject["dateFormatter"] = shortDate
        
        //compress the image before upload
        // image convertion
        let imageDataa = UIImageJPEGRepresentation(imageView.image!, 0.25)
        let imageFile = PFFile(name:"image.JPEG", data:imageDataa!)
        itemObject["imageFile"] = imageFile


    // sending the data to parse
        itemObject.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // The object has been saved.
                } else {
                    // There was a problem, check error.description
                }
            }
        
        
        
        }
    
    
// MARK: - Functions/Methods
    
    //To dismess the keyboard by pressing the "Return Key"
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // Convert the Latitude and Longtitude to streetname, cityname, zipcode and country
    func addressMaker() {
        let manager = CLLocationManager()
        if let locator = manager.location?.coordinate {
            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: locator.latitude, longitude: locator.longitude )
            geoCoder.reverseGeocodeLocation(location)
                {
                    (placemarks, error) -> Void in
                    
                    let placeArray = placemarks as [CLPlacemark]!
                    
                    // Place details
                    var placeMark: CLPlacemark!
                    placeMark = placeArray?[0]
                    
                    // Address dictionary
                    print(placeMark.addressDictionary)
                    
                    // Location names
                    let street = placeMark.addressDictionary?["Thoroughfare"] as! NSString
                    let city = placeMark.addressDictionary?["City"] as! NSString
                    let country = placeMark.addressDictionary?["Country"] as! NSString

                    self.locationLabel.text = "\(street), \(city), \(country)"
                    
            }
            
        }
    }
    
    


    
    
    // Override the viewDidLoad function
    override func viewDidLoad() {
        super.viewDidLoad()
     // put the photo in the imageView
        imageView.image = image
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Gives the current date to the date label
        let time = NSDate()
        dateLabel.text = dateFormatter.stringFromDate(time)
        
        // Gives the current location to the locationlabel
        addressMaker()
    }

    
    
    
    
    
    
}