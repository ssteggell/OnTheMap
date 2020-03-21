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
    
    override func viewWillAppear(_ animated: Bool){
        
        self.LoadDataPoints()
    }
    
    override func viewDidLoad(){
        
        
    }
    
    
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
           
            self.StudentLocationMap.addAnnotations(self.annotations)
        }
        
        
    }
    

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
           
           let reuseId = "pin"
           
           var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
           
           if pinView == nil
           {
               pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
               pinView!.canShowCallout = true
               pinView!.pinTintColor = .cyan
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

    
    override func reloadInputViews()
    {
        LoadDataPoints()
        //print(loadDataPoints())
    }
    
}
