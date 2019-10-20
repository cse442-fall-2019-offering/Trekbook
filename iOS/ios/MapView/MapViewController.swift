//
//  MapViewController.swift
//  iOS
//
//  Created by Dennis Fedorishin on 9/19/19.
//  Copyright © 2019 Trekbook. All rights reserved.
//

import UIKit
import Mapbox
 
class MapViewController: UIViewController, MGLMapViewDelegate {
    var mapView: MGLMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
         
        // Set the map’s center coordinate and zoom level.
        mapView.setCenter(CLLocationCoordinate2D(latitude: 40.7326808, longitude: -73.9843407), zoomLevel: 12, animated: false)
        view.addSubview(mapView)
         
//        // Set the delegate property of our map view to `self` after instantiating it.
        mapView.delegate = self
         
//        // Declare the marker `hello` and set its coordinates, title, and subtitle.
//        let hello = MGLPointAnnotation()
//        hello.coordinate = CLLocationCoordinate2D(latitude: 40.7326808, longitude: -73.9843407)
//        hello.title = "Hello world!"
//        hello.subtitle = "Welcome to my marker"
//
//        // Add marker `hello` to the map.
//        mapView.addAnnotation(hello)
        
        // Add a single tap gesture recognizer. This gesture requires the built-in MGLMapView tap gestures (such as those for zoom and annotation selection) to fail.
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleMapTap(sender:)))
        for recognizer in mapView.gestureRecognizers! where recognizer is UILongPressGestureRecognizer {
            longPress.require(toFail: recognizer)
        }
        mapView.addGestureRecognizer(longPress)
        
    }
    
    @objc @IBAction func handleMapTap(sender: UILongPressGestureRecognizer) {
        // Convert tap location (CGPoint) to geographic coordinate (CLLocationCoordinate2D).
        let tapPoint: CGPoint = sender.location(in: mapView)
        let tapCoordinate: CLLocationCoordinate2D = mapView.convert(tapPoint, toCoordinateFrom: mapView)
        print("You tapped at: \(tapCoordinate.latitude), \(tapCoordinate.longitude)")
        let new_marker = MGLPointAnnotation()
        new_marker.coordinate = tapCoordinate
        let activity_desc = UIAlertController(title: "Enter Description", message: "Name of Location", preferredStyle: .alert)
        
        
        activity_desc.addAction (UIAlertAction(title: "Save", style: .default) { (alertAction) in
            let activity_title = activity_desc.textFields![0].text!
            let activity_details = activity_desc.textFields![1].text!
            new_marker.title = activity_title
            new_marker.subtitle = activity_details
        })
        
        activity_desc.addTextField { (textField) in
            textField.placeholder = "title"
            textField.textColor = .red
        }
        
        activity_desc.addTextField { (textField) in
            textField.placeholder = "details"
            textField.textColor = .blue
        }
        
        activity_desc.addAction(UIAlertAction(title: "Cancel", style: .default) { (alertAction) in })
        self.present(activity_desc, animated:true, completion: nil)
        
        
        mapView.addAnnotation(new_marker)
    }
 
//    // Use the default marker. See also: our view annotation or custom marker examples.
//    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
//        return nil
//    }

    // Allow callout view to appear when an annotation is tapped.
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
}
