//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Spencer Steggell on 3/21/20.
//  Copyright © 2020 Spencer Steggell. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class AddLocationViewController: UIViewController, UINavigationControllerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var URLTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var addLocationButton: UIButton!
    
    @IBOutlet weak var findLocationMap: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func setWorkingAnimation(animate: Bool) {
      if animate
      {
          activityIndicator.startAnimating()
      }
      else {
          activityIndicator.stopAnimating()
      }
      }
//    When the user enters in the location and URL, this validates the location is entered correctly and verified to be a location, then the URL is checked whether it can be opened or not. If everything is successful, it will open the map and take the user to the location and ask to confirm the post.
    @IBAction func findLocation(_ sender: Any) {
        
        print("Find Location Button Pressed")
        self.setWorkingAnimation(animate: true)
        if self.locationTextField.text == "" {
             showLoginFailure(message: "THE ADDRESS CANNOT BE BLANK.  PLEASE FILL IN CITY / STATE", titleVal: "INVALID ADDRESS")
                return
        }
        print("location filled in")
        if self.URLTextField.text == "" {
            showLoginFailure(message: "The URL Cannot Be Blank. Please fill in URL", titleVal: "INVALID URL")
            return
        }
        print("URL filled in")
        guard let urlVal = URL(string:self.URLTextField.text ?? "na")
            else {
        return
        }
        let validURL = UIApplication.shared.canOpenURL(urlVal)
        if !validURL {
            showLoginFailure(message: "Please enter a valid URL and format with HTTP://exampleurl.com", titleVal: "INVALID URL")
            return
        }
        print("location and url validated")
        if UdacityClient.validateAddressEntered(address: self.locationTextField.text ?? "", completion: self.HandleLocationCheckResponse(locationExists:error:)) {
        }
    }
    
    
    @IBAction func postLocation(_ sender: Any) {
        
        let URLStr = URLTextField.text ?? ""
        UdacityClient.postStudentLocation(mapStringLocation: locationTextField.text ?? "", mediaUrlStr: URLStr, completion: self.HandlePostUserResponse(successfulPost:error:))
    }

//    Checks whether or not location exists and calls function that sets map to location.
    func HandleLocationCheckResponse(locationExists: Bool, error: Error?) {
        if locationExists
        {
              
            print("WE FOUND THE ENTERED LOCATION")
            print("LOCATION EXISTS \(self.locationTextField.text ?? "") ")
            print("LATITUDE: \(UdacityClient.LocationDetail.latitudeVal)")
            print("LONGITUDE: \(UdacityClient.LocationDetail.longitudeVal)")
            
            SetMaptoUserLocation()
            showUserLocation(mapHiddenFlag: false)
            setWorkingAnimation(animate: false)
              
        }
            
          else
        {
              showLoginFailure(message: "PLEASE ENTER ADDRESS IN THE FORMAT CITY, STATE OR MAKE SURE YOUR SPELLING IS CORRECT", titleVal: "INVALID ADDRESS")
        }
    }
    
    func HandlePostUserResponse(successfulPost:Bool, error: Error?) {
        
        print("THE POSTING HAS THE FOLLOWING STATUS \(successfulPost)")
        print("LATITUDE: \(UdacityClient.LocationDetail.latitudeVal)")
        print("LONGITUDE: \(UdacityClient.LocationDetail.longitudeVal)")
        
        if(successfulPost)
        {
            navigationController?.popViewController(animated: true)
        }
            
        else
        {
            showLoginFailure(message: "FAILED TO POST USER LOCATION", titleVal: "POSTING FAILURE")
        }
    }
    
//    Actual function used to set map to location.
    func SetMaptoUserLocation() {
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: UdacityClient.LocationDetail.latitudeVal, longitude: UdacityClient.LocationDetail.longitudeVal), span: MKCoordinateSpan(latitudeDelta: 0.10, longitudeDelta: 0.10))
        self.findLocationMap.setRegion(region, animated: true)
        
        var annotations = [MKPointAnnotation]()
        
        let coordinate = CLLocationCoordinate2D(latitude: UdacityClient.LocationDetail.latitudeVal, longitude: UdacityClient.LocationDetail.longitudeVal)
        
        let annotation = MKPointAnnotation()
        let locationTextVal = locationTextField.text ?? ""
        annotation.coordinate = coordinate
        annotation.title = "\(locationTextVal)"
        annotation.subtitle = "\(URLTextField.text ?? "")"
        annotations.append(annotation)
        self.findLocationMap.addAnnotations(annotations)
        self.findLocationMap.reloadInputViews()
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil
        {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        else
        {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        if control == view.rightCalloutAccessoryView
        {
            if let toOpen = view.annotation?.subtitle!
            {
                UIApplication.shared.open(URL(string: toOpen)! , options: [:], completionHandler: nil)
            }
        }
    }
//    Used to bring up the map and hide the text fields.
    func showUserLocation(mapHiddenFlag: Bool) {
        
        if mapHiddenFlag == false {
            locationTextField.isHidden = true
            URLTextField.isHidden = true
            findLocationButton.isHidden = true
        } else {
            locationTextField.isHidden = false
            URLTextField.isHidden = false
            findLocationButton.isHidden = false
        }
        findLocationMap.isHidden = mapHiddenFlag
        addLocationButton.isHidden = mapHiddenFlag
    }
    
    
    
    func showLoginFailure(message: String, titleVal: String)
       {
           let alertVC = UIAlertController(title: titleVal, message: message, preferredStyle:.alert)
           alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           self.present(alertVC, animated: true, completion: nil)
       }
    
}
