//
//  PinImageViewController.swift
//  MarkJai
//
//  Created by Juwendsley Felicia on 25-02-16.
//  Copyright © 2016 Mark.Jai. All rights reserved.
//


import MapKit

class PinImageViewController: MKPointAnnotation {
    
    var imageFiles: PFObject!
    
    init(object: PFObject) {
        super.init()
        
        imageFiles = object
    }
    
}