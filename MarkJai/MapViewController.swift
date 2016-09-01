//
//  MapViewController.swift
//  MarkJai
//
//  Created by Juwendsley Felicia on 15-02-16.
//  Copyright © 2016 Mark.Jai. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


// MARK: - Class

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
// MARK: - Properties
    
    // Create ParseArray
    var parseFiles =  [PFObject]()
    
// MARK: - Initializers
    
// MARK: - Instance
    
    var locationManager: CLLocationManager!
    
// MARK: - Outlets
    
    @IBOutlet var mapView: MKMapView!

    
// MARK: - Actions
    
    // This action let the user go back to his current location with the "Get Location" button.
    @IBAction func getCurrentLocation(sender: AnyObject) {
    // These constants wil give the zoomed view from the user location, can be edited by the coordinates
        let spanX = 0.005
        let spanY = 0.005
        
    // Create a region using the user's location, and the zoo.
        let newRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
        
    // set the map to the new region
        mapView.setRegion(newRegion, animated: true)
    }
    


    
    // This action let the user switch from different mapviews, to satilite and standard
    @IBAction func segmentedControl(sender: AnyObject) {
        switch sender.selectedSegmentIndex {
        case 1: mapView.mapType = MKMapType.SatelliteFlyover
        default: mapView.mapType = MKMapType.Standard
        }
    }
    
    
    // This action let the user take an photo with the "Camera" Button
    @IBAction func tacePicture(sender: UIButton) {
        
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.Camera){
            imagePicker.sourceType = .Camera
        }else{
            imagePicker.sourceType = .PhotoLibrary
        }
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion: nil)
    }



    
// MARK: - Function/Methods
    
    // This function let the user go to their current location when first opening the app
    func locationManager(manager: CLLocationManager, didUpdateToLocation
        newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
    // This constant wil give the zoomed view from the user location, can be edited by the coordinates
        let region = MKCoordinateRegionMakeWithDistance(
        newLocation.coordinate, 350, 350)
        mapView.setRegion(region, animated: true)
            
    // This enable the user to scrol on the map
        locationManager.stopUpdatingLocation()
    }



    // This function is used when the action "tacePicker" is active, than you can send the picture and open a new view
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    // Get picked image from info dictionary
        let image = info[UIImagePickerControllerOriginalImage] as!UIImage
    // Dismiss the camera
        self.dismissViewControllerAnimated(true, completion: nil)
    // Making a constant that tell to navigate to "AddPhotoViewController" (in the storyboard, put the Storyboard ID)
        let newViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AddPhotoViewController") as? AddPhotoViewController
    // Putting the photo in the new view controller "AddPhotoViewController" in the imageView
        newViewController?.image = image
    // Going to the new viewcontroller "AddPhotoViewController"
        self.presentViewController(newViewController!, animated: true, completion: nil)
    }



    //
    
    // Showing the pin on the map
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation) {
            return nil
        }
        else {
            let identifier = "MyPin"

//            let customAnnotation = annotation as! MyNewAnnotations
//            

            // Hergebruik de Annotation als het mogelijk is
            var annotationView:MKPinAnnotationView? = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView
        
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                annotationView?.animatesDrop = true

            }
            

            if  let customAnnotation = annotation as? MyNewAnnotations {
                let myObject = customAnnotation.currentObject
                let objectFile = myObject!["imageFile"]

            
            let leftIconView = PFImageView(frame: CGRectMake(0, 0, 53, 53))
            
            // Get PFFIle out of PFObject, and fill it in below.
            //leftIconView.file = objectFile.valueForKey("PhotoPin") as? PFFile
            leftIconView.file = objectFile as? PFFile
            leftIconView.loadInBackground()
            
            
            
            annotationView?.leftCalloutAccessoryView = leftIconView
            
            }
        
        
//            let leftIconView = PFImageView(frame: CGRectMake(0, 0, 53, 53))
////            leftIconView.file = objectFile as? PFFile
//            annotationView?.leftCalloutAccessoryView = leftIconView
//            leftIconView.loadInBackground()
//
//            return annotationView
        return annotationView
        }
    }
    
    


    





    var myAnnotations = [PFObject]()
    
    func annotationsFromParse() {
        let query = PFQuery(className: "PhotoPin")
        // Order the photo's on date they createdAt
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock {
            (posts, error) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successful query for annotations")
                self.myAnnotations = posts!
                
                for post in posts! {
                    let point = post ["locationLabel"] as! PFGeoPoint
                    
                    
                    let annotation = MyNewAnnotations (object: post)
                    annotation.coordinate = CLLocationCoordinate2DMake(point.latitude, point.longitude)
                    
//                    annotation.image.file = post.valueForKey("imageFile") as? PFFile
                    annotation.title = post.valueForKey("photoName") as? String
                    annotation.subtitle = post.valueForKey("photoDescription") as? String
                    
                    self.mapView.addAnnotation(annotation)
                    
                    print(post.valueForKey("locationLabel"))
                }
            } else {
                print("Error: \(error)")
            }
            
        }
        
    }
    
    
    
    
    
    // This function will be used when this "MapViewController" is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        annotationsFromParse()
        // It its needed to display the map
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        
        // This will check if the location facility in enabled on the device
        let status = CLLocationManager.authorizationStatus()
        if status == .NotDetermined || status == .Denied || status
            == .AuthorizedWhenInUse {
        // present an alert indicating location authorization required
        // and offer to take the user to Settings for the app via
        // UIApplication -openUrl: and UIApplicationOpenSettingsURLString
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        // update the cocation
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
  
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        let annotation = MKPointAnnotation()
        mapView.showAnnotations([annotation], animated: true)
        mapView.selectAnnotation(annotation, animated: true)
        
        
    }
    
    
    
    // Checks for enough memory on the device
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        annotationsFromParse()
        // It its needed to display the map
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        
        // This will check if the location facility in enabled on the device
        let status = CLLocationManager.authorizationStatus()
        if status == .NotDetermined || status == .Denied || status
            == .AuthorizedWhenInUse {
                // present an alert indicating location authorization required
                // and offer to take the user to Settings for the app via
                // UIApplication -openUrl: and UIApplicationOpenSettingsURLString
                locationManager.requestAlwaysAuthorization()
                locationManager.requestWhenInUseAuthorization()
        }
        // update the location
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        let annotation = MKPointAnnotation()
        mapView.showAnnotations([annotation], animated: true)
        mapView.selectAnnotation(annotation, animated: true)
    }

}



