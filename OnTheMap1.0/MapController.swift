//
//  MapController.swift
//  OnTheMap1.0
//
//  Created by Alexis Omar Marquez Castillo on 14/05/20.
//  Copyright © 2020 udacity. All rights reserved.
//

import UIKit
import MapKit
import SafariServices
var studentLocation : LoctationStudents?

class MapController: UIViewController {
   
    
    var updateMapView: (() -> ())?
    var updateTableView: (() -> ())?
    var studentPin: StudentPin!
    
    @IBOutlet weak var mapView: MKMapView!
    private var annotations = [MKPointAnnotation]()
    
    var session = ViewController.finishedSession
    var sess : Session?
    
    override func viewDidLoad() {
        mapView.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        
        
        
        
        
        // getAllUsersData()
        
        
        getPines()
        
    }
    func getPines(){
        APIManager.sharedInstance.getStudentsLocations { (result) in
            switch result {
            case .Success(let location):
                var map = [MKPointAnnotation]()
                for location in location.results {
                    let long = CLLocationDegrees(location.longitude ?? 0.0)
                    let lat = CLLocationDegrees(location.latitude ?? 0.0)
                    let cords = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    let mediaURL = location.mediaURL ?? " "
                    let firstName = location.firstName ?? " "
                    let lastName = location.lastName ?? " "
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = cords
                    annotation.title = "\(firstName) \(lastName)"
                    annotation.subtitle = mediaURL
        
    

                    map.append(annotation)
                }
                DispatchQueue.main.async {
                    self.mapView.addAnnotations(map)
                }
                
                
            case .Error(let error):
                print(error)
                
            }
        }
    }
    
    

    
    
    @IBAction func addPin(_ sender: Any) {
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
        self.navigationController!.pushViewController(VC1, animated: true)
    }
    @IBAction func logOutTapped(_ sender: Any) {
        logout { (success, error) in
            if success == true {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                
            }
        }
        
        
    }
    
    
    
    @IBAction func refresh(_ sender: Any) {
        
        getPines()
        //refresh mapView
    
    }
    
  
}







func logout(completion: @escaping(_ success: Bool, _ error: String?) -> Void){
    
    var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
    request.httpMethod = "DELETE"
    var xsrfCookie: HTTPCookie? = nil
    let sharedCookieStorage = HTTPCookieStorage.shared
    for cookie in sharedCookieStorage.cookies! {
        if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
    }
    if let xsrfCookie = xsrfCookie {
        request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
    }
    let session = URLSession.shared
    let task = session.dataTask(with: request) { data, response, error in
        if error != nil { // Handle error…
            completion(false, error?.localizedDescription)
            return
        }
        completion(true, nil)
        let range = (5..<data!.count)
        let newData = data?.subdata(in: range) /* subset response data! */
        print(String(data: newData!, encoding: .utf8)!)
    }
    task.resume()
    
}




extension MapController: MKMapViewDelegate {
    
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let url = view.annotation?.subtitle
        print("url is: \(String(describing: url))")
        if let url = URL(string: (url ?? "")!)
        {
            UIApplication.shared.open(url)
        }
    }

    }

    
    
    
    





