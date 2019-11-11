//
//  MapBoxViewController.swift
//  iOS
//
//  Created by Dennis Fedorishin on 11/10/19.
//  Copyright © 2019 Trekbook. All rights reserved.
//

import Foundation
import UIKit
import Mapbox

class MapBoxViewController: UIViewController, MGLMapViewDelegate {
    @IBOutlet weak var MapBoxView: MGLMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        MapBoxView.setCenter(CLLocationCoordinate2D(latitude: 40.7326808, longitude: -73.9843407), zoomLevel: 4, animated: false)
        
        MapBoxView.delegate = self
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleMapTap(sender:)))
        for recognizer in MapBoxView.gestureRecognizers! where recognizer is UILongPressGestureRecognizer {
            longPress.require(toFail: recognizer)
        }
        MapBoxView.addGestureRecognizer(longPress)
    }
    
    @objc @IBAction func handleMapTap(sender: UILongPressGestureRecognizer) {
            // Convert tap location (CGPoint) to geographic coordinate (CLLocationCoordinate2D).
            let tapPoint: CGPoint = sender.location(in: MapBoxView)
            let tapCoordinate: CLLocationCoordinate2D = MapBoxView.convert(tapPoint, toCoordinateFrom: MapBoxView)
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
            
            
            MapBoxView.addAnnotation(new_marker)
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
