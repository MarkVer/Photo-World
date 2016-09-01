//
//  PhotoPinFile.swift
//  MarkJai
//
//  Created by Juwendsley Felicia on 24-02-16.
//  Copyright © 2016 Mark.Jai. All rights reserved.
//

import UIKit
import MapKit

class PhotoPinFile: NSObject, MKAnnotation {

    var coordinate: CLLocationCoordinate2D
    var photoName: String?
    var photoDescription: String?
    var image: PFImageView!
   var currentObject: PFObject?

    init(object: PFObject) {
        let point = object.valueForKey("currentLocation")
        let loc = CLLocationCoordinate2DMake(point!.latitude, point!.longitude)

        self.coordinate = loc
        self.photoName = object["photoName"] as? String
        self.photoDescription = object ["photoDescription"] as? String
        self.currentObject = object
    }
//    
//    
}


