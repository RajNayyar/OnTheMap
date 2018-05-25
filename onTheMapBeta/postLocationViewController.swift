//
//  postLocationViewController.swift
//  onTheMapBeta
//
//  Created by Rajpreet on 25/01/18.
//  Copyright © 2018 Rajpreet. All rights reserved.
//

import UIKit
import MapKit

class postLocationViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate {

    @IBOutlet weak var locationTextField: UITextField!
   @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var pinButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var mapLatitude: CLLocationDegrees? = nil
    var mapLongitude: CLLocationDegrees? = nil
   
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.isHidden = true
        self.hideKeyboardWhenTappedAround() 
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
    }

   func Error(name: String)
    {
      let alert = UIAlertController(title: "Error", message: name, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func searchAction(_ sender: Any) {
        spinner.isHidden=false
        spinner.hidesWhenStopped=true
        spinner.activityIndicatorViewStyle  = .gray
        spinner.startAnimating()
        if let spinner = spinner {
            self.view.addSubview(spinner)
        }
        let geocoder = CLGeocoder()
        guard (locationTextField) != nil
        else
        {
            Error(name: "Enter location")
            return
        }
        guard (websiteTextField) != nil
        else
        {
            Error(name: "Enter Valid Website")
            return
        }
        
        geocoder.geocodeAddressString(locationTextField.text!) { (placemarks, error) in
            
            if error != nil {
                self.Error(name: "Location not found")
                self.spinner.isHidden=true
            }
            else {
                let placemark = placemarks?.first
                
                if let placemark = placemark {
                    let coordinates = placemark.location?.coordinate
                    
                    let span = MKCoordinateSpanMake(0.05, 0.05)
                    let region = MKCoordinateRegion(center: coordinates!, span: span)
                    
                    let annotation = MKPointAnnotation()
                    
                    annotation.coordinate = coordinates!
                    
                    self.mapLatitude = coordinates?.latitude
                    self.mapLongitude = coordinates?.longitude
                    
                    DispatchQueue.main.async {
                        self.mapView.removeAnnotation(annotation)
                        self.mapView.addAnnotation(annotation)
                        self.mapView.setRegion(region, animated: true)
                        self.spinner.isHidden=true
                    }
                    
                } else {
                    self.Error(name: "No match found")
                }}}}
    
    
    
    @IBAction func pinAction(_ sender: Any) {
        if((locationTextField.text?.isEmpty)! || (websiteTextField.text?.isEmpty)! || locationTextField.text=="Enter Location" || websiteTextField.text=="Enter Website")
        {
            self.Error(name: "please enter location and URL")
        }
        
      else{
        parseUser.sharedInstance().postLocation(mapString: locationTextField.text!, mediaUrl: websiteTextField.text!, latitude: mapLatitude!, longitude: mapLongitude!) { (result, success, error) in
            if error != nil{
                DispatchQueue.main.async {
                    self.Error(name: "Please check your internet connection")
                }
                return
            }
            else{
               _=result
                }
            
            }
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
            self.spinner.isHidden=true
        }
        }
    }
  
    @IBAction func cancel(_ sender: Any) {
   self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
