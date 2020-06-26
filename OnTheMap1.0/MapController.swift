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
    enum Result<T> {
        case Success(T)
        case Error(String)
    }

  var updateMapView: (() -> ())?
  var updateTableView: (() -> ())?
  
    @IBOutlet weak var mapView: MKMapView!
    private var annotations = [MKPointAnnotation]()
    
    var session = ViewController.finishedSession
     
    
   
      override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
         // getAllUsersData()
        
       
        getStudentsLocations { (result) in
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
    
       

    func getStudentsLocations(completion:@escaping (Result<LoctationStudents>)->Void){
           
           let urlString = "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt"
           let url = URL(string: urlString)
           var request = URLRequest(url: url!)
           request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
           request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
           let session = URLSession.shared
           let task = session.dataTask(with: request) { data, response, error in
              
            if let data = data {
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(LoctationStudents.self, from: data)
                 completion(.Success(result))
                    studentLocation = result
                    
                    
                } catch  {
                    completion(.Error(error.localizedDescription))
                    print("there is error in decoding data\n")
                    print(error.localizedDescription)
                 }
               
            } else {
                completion(.Error(error?.localizedDescription ?? ""))
            }
        }

        task.resume()

}

    
        
        
    
    @IBAction func addPin(_ sender: Any) {
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
        self.navigationController!.pushViewController(VC1, animated: true)
    }
    @IBAction func logOutTapped(_ sender: Any) {
        logout { (success, error) -> Void
            if success {
                   DispatchQueue.main.async {
                       self.navigationController?.popToRootViewController(animated: true)
                   }
               } else {
                   DispatchQueue.main.async {
 
            }

            }
        }
    }
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

}

}


