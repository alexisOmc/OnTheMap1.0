//
//  LocationStudentMapViewController.swift
//  OnTheMap1.0
//
//  Created by Alexis Omar Marquez Castillo on 12/06/20.
//  Copyright © 2020 udacity. All rights reserved.
//

import UIKit
import MapKit
class LocationStudentMapViewController: UIViewController, MKMapViewDelegate{
    
    @IBOutlet weak var studemtMapView: MKMapView!
    static let shared = LocationStudentMapViewController()
    // var location: StudentLocationList?
    var selectedLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var locationTitle = ""
    var url = ""
    var locationStudent : Result?
    var session : Seession?
    var userData : UserData?
    var sess : Session?
    var objectId: String?
    
    var firstName : String?
    var lastName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        studemtMapView.delegate = self
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        
        
        
        
        getUser { (success, error) in
            if success == true{
                
                var map = [MKPointAnnotation]()
                let long = CLLocationDegrees(studentPin.coordinate.longitude)
                let lat = CLLocationDegrees(studentPin.coordinate.latitude )
                let cords = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let mediaURL = studentPin!.mediaURL
                let name = self.firstName
                let lastN = self.lastName
                let annotation = MKPointAnnotation()
                annotation.coordinate = cords
                annotation.title = "\(String(describing: name)) \(String(describing: lastN))"
                annotation.subtitle = mediaURL
                map.append(annotation)
                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                DispatchQueue.main.async {
                    self.studemtMapView.addAnnotations(map)
                    let region = MKCoordinateRegion(center: cords, span: span)
                    self.studemtMapView.setRegion(region, animated: true)
                    
                }
            }else{
                
                
            }
        }
    }
    
    func createAnnotation(){
        let annotation = MKPointAnnotation()
        annotation.title = locationStudent?.mapString
        annotation.subtitle = locationStudent?.mediaURL
        annotation.coordinate = CLLocationCoordinate2DMake(locationStudent?.latitude ?? 0.0, locationStudent?.longitude ?? 0.0)
        self.studemtMapView.addAnnotation(annotation)
        
        
        //zooming to location
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(locationStudent?.latitude ?? 0.0, locationStudent?.longitude ?? 0.0)
        
        
    }
    
    @IBAction func finishTapped(_ sender: Any) {
        
        postStudent { (success, error) in
            if success == true {
                
            } else {
                
            }
        }
        
    }
    @IBAction func postLocation(_ sender: Any) {
        
    }
    func getUser(completionHandler: @escaping (_ success: Bool, _ error: String?) -> Void) {
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/\(ViewController.finishedSession?.account.key ?? "")")!)
        let task = URLSession.shared.dataTask(with:request, completionHandler: { (data, response, error) -> Void in
            if error != nil { // Handle error...
                return
            }
            let range = (5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            
            let dataNew = (String(data: newData!, encoding: .utf8)!)
            
            var dictonary:NSDictionary?
            
            if let data = dataNew.data(using: String.Encoding.utf8) {
                
                do {
                    dictonary =  try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] as NSDictionary?
                    
                    
                    if let myDictionary = dictonary
                    {
                        
                        if let name = myDictionary["first_name"] as? String {
                            self.firstName = name
                            
                        }
                        if let name = myDictionary["last_name"] as? String {
                            self.lastName = name
                            
                        }
                        completionHandler(true,nil)
                        
                        
                    }
                } catch let error as NSError {
                    completionHandler(false ,error.localizedDescription)
                    print(error)
                }
            }
            
        })
        task.resume()
    }
    
    
    
    
    
    
    
    
    
    func postStudent(completionHandler: @escaping (_ success: Bool, _ error: String?) -> Void) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \(firstName!)\", \"lastName\": \(lastName!)\",\"mapString\": \(studentPin!.mapString)\", \"mediaURL\": \(studentPin!.mediaURL)\",\"latitude\": \(studentPin!.coordinate.latitude), \"longitude\": \(studentPin!.coordinate.longitude)}".data(using: .utf8)
        
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completionHandler(false, error?.localizedDescription)// Handle error…
                return
                
            }
            completionHandler(true,nil)
            DispatchQueue.main.async {
                
                self.navigationController?.popToRootViewController(animated: true)
            }
            print(String(data: data!, encoding: .utf8)!)
            
        }
        task.resume()
        
    }
    
    func putStudentLocation(objectID: String,  completion: @escaping (Bool, Error?) -> Void) {
        let urlString = "https://onthemap-api.udacity.com/v1/StudentLocation/: \"\(String(describing: objectID))"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(String(describing: locationStudent?.uniqueKey))\", \"firstName\": \"\(String(describing: userData?.firstName))\", \"lastName\": \"\(String(describing: userData?.lastName))\",\"mapString\": \"\(String(describing: locationStudent?.mapString))\", \"mediaURL\": \"\(String(describing: locationStudent?.mediaURL))\",\"latitude\": \(String(describing: locationStudent?.latitude)), \"longitude\": \(String(describing: locationStudent?.longitude))}".data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
    }
    
}
extension LocationStudentMapViewController {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseid = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseid) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseid)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
}
