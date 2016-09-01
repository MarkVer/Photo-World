
//
//  Annotations.swift
//  TeamApp
//
//  Created by Ivo Duits on 23-02-16.
//  Copyright © 2016 Ivo Duits. All rights reserved.
//

import UIKit
import MapKit


class MyNewAnnotations : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var image: PFImageView!
    var currentObject: PFObject?
    
    
    init(object: PFObject) {
        let point = object.valueForKey("locationLabel")
        let loc = CLLocationCoordinate2DMake(point!.latitude, point!.longitude)
        
        self.coordinate = loc
        self.title = object["photoName"] as? String
        self.subtitle = object ["photoDescription"] as? String
//        self.image.file = object ["imageFile"] as? PFFile
        self.currentObject = object
    }
    
    
}
