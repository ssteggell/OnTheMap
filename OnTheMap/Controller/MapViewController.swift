//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Spencer Steggell on 3/16/20.
//  Copyright © 2020 Spencer Steggell. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var StudentLocationMap: MKMapView!
    var annotations = [MKPointAnnotation]()
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool){
        self.refreshButtonList()
  
    }
//    Adds the buttons to the top of the view controller
    override func viewDidLoad() {
        let barButtonItemAddLoc = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        let refreshButtonItemAddLoc = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshButtonList))
        navigationItem.rightBarButtonItems = [barButtonItemAddLoc, refreshButtonItemAddLoc]
    }
    
    @objc func addButtonPressed() {
        let addLocVC = storyboard!.instantiateViewController(withIdentifier: "AddLocationViewController")  as! AddLocationViewController
        navigationController?.pushViewController(addLocVC, animated: true)
    }
//    Function when the refresh button is pressed to reload all the data points.
    @objc func refreshButtonList() {
        
                self.setWorkingAnimation(animate: true)
                self.StudentLocationMap.removeAnnotations(annotations)
                self.LoadDataPoints()
    }
    
    func setWorkingAnimation(animate: Bool) {
        if animate
        {
            loadingIndicator.startAnimating()
        }
        else {
            DispatchQueue.main.async {
          
                self.loadingIndicator.stopAnimating()
            }
        }
    }
//    Function to use the network request to get the locations of all the students.
    func LoadDataPoints() {
        UdacityClient.getStudentLocation{ (data, error) in
            guard let data = data else {
                print ("Unable to load data points")
                return
            }
            
            StudentModel.studentList = data
            
            for student in data {
                
                let lat = CLLocationDegrees(student.latitude)
                let long = CLLocationDegrees(student.longitude)
                
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let firstName = student.firstName
                let lastName = student.lastName
                let mediaURL = student.mediaURL
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(firstName) \(lastName)"
                annotation.subtitle = mediaURL
                self.annotations.append(annotation)
            
                print(self.annotations)
            }
            self.setWorkingAnimation(animate: false)
            self.StudentLocationMap.addAnnotations(self.annotations)
        }
        
        
    }
    
//  Function used to create all the annotaitons.
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
//    Used to add the subtitles to the annotations.
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

}

