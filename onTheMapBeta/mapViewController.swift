//
//  mapViewController.swift
//  onTheMapBeta
//
//  Created by Rajpreet on 21/01/18.
//  Copyright © 2018 Rajpreet. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class mapViewController: UIViewController, MKMapViewDelegate {
    

    @IBOutlet weak var mapView: MKMapView!
    var annotations = [MKPointAnnotation]()
    
    
    @IBOutlet weak var addbutton: UIBarButtonItem!
    
    
    @IBOutlet weak var logOutAction: UIBarButtonItem!
    
    
    @IBAction func addNewPin(_ sender: Any) {
        let postController = storyboard?.instantiateViewController(withIdentifier: "post")
        present(postController! , animated: true, completion: nil)
    }
    func fillMap() {
        parseUser.sharedInstance().showLocation() { (loc, success, error) in
            if success {
                for location in loc! {
                    if let latitude = location.latitude, let longitude = location.longitude,
                        let firstName = location.firstName, let lastName = location.lastName,
                        let mediaURL =  location.mediaURL {
                        let annotation = MKPointAnnotation()
                        let lattDegrees = CLLocationDegrees(latitude)
                        let longDegrees = CLLocationDegrees(longitude)
                        let coordinate = CLLocationCoordinate2D(latitude: lattDegrees, longitude: longDegrees)
                        if mediaURL.isEmpty {
                            annotation.subtitle = udacityParsingConstants.defaultURL
                        } else {
                            annotation.subtitle = mediaURL
                        }
                        annotation.title = "\(firstName) \(lastName)"
                       annotation.coordinate = coordinate
                        self.annotations.append(annotation)
                    }
                    
                }
                DispatchQueue.main.async {
                    self.mapView.removeAnnotations(self.annotations)
                    self.mapView.addAnnotations(self.annotations)
                }
            }
            else {
                self.showError(error!)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        DispatchQueue.main.async {
            self.mapView.addAnnotations(self.annotations)
        }
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
            self.fillMap()
        
    }
    func showError(_ error: String) {
        let alert = UIAlertController(title: "Error!", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func canVerifyUrl(urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url  = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "reuse"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle {
                if canVerifyUrl(urlString: toOpen) {
                    app.open(URL(string: toOpen!)!, options: [:], completionHandler: nil)
                } else {
                    showError("URL not valid and could not be opened")
                }
            }
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        udacityUser.sharedInstance().endUserSession { (success, error) in
            if success {
                self.tabBarController?.dismiss(animated: true, completion: nil)
            } else {
                self.showError(error!)
            }
        }
    }
    
}
