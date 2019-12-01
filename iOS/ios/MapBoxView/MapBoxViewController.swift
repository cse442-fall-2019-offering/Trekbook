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

@available(iOS 13.0, *)
@available(iOS 13.0, *)
@available(iOS 13.0, *)
@available(iOS 13.0, *)
class MapBoxViewController: UIViewController, MGLMapViewDelegate {
    @IBOutlet weak var myProfileButton: UIButton!
    @IBOutlet weak var myFriendsButton: UIButton!
    @IBOutlet weak var myLogoutButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var creatorLabel: UILabel!
    
    @IBOutlet weak var MapBoxView: MGLMapView!
    
    var delegate: MapBoxViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
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
                
                api_submit_marker(userid: (User?.data.userId)!, title: new_marker.title ?? "", description: new_marker.subtitle ?? "", latitude: Float(tapCoordinate.latitude), longitude: Float(tapCoordinate.longitude)) { (success) in
                    if success {
                        print("marker added!")
                    }
                }
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
     
        func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
            return true
        }
    @IBAction func LogoutButtonPressed(_ sender: Any) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            UIApplication.shared.keyWindow?.rootViewController = vc
        }
    }
}

@available(iOS 13.0, *)
extension MapBoxViewController: SidePanelViewControllerDelegate {
  func didSelectFriend(_ friend: Friend) {
    imageView.image = friend.image
    titleLabel.text = friend.title
    creatorLabel.text = friend.creator
    
    delegate?.collapseSidePanels()
  }
}

protocol MapBoxViewControllerDelegate {
  func toggleLeftPanel()
  func toggleRightPanel()
  func collapseSidePanels()
}
