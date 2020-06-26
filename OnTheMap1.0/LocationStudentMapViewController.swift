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
    override func viewDidLoad() {
        super.viewDidLoad()
        studemtMapView.delegate = self
        }
          
          override func viewWillAppear(_ animated: Bool) {
              super.viewWillAppear(true)
            
            
              createAnnotation()
            getUser { (success, error) in
                if success == true{
                    
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
              let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
              let region = MKCoordinateRegion(center: coordinate, span: span)
              self.studemtMapView.setRegion(region, animated: true)
              
          }

    @IBAction func finishTapped(_ sender: Any) {
        
    }

    @IBAction func postLocation(_ sender: Any) {
    
}
      func getUser(completionHandler: @escaping (_ success: Bool, _ error: String?) -> Void) {
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/\(ViewController.finishedSession?.account.key ?? "")")!)
        let task = URLSession.shared.dataTask(with:request, completionHandler: { (data, response, error) -> Void in
              guard let data = data else {
                  DispatchQueue.main.async {
                      completionHandler(false, nil)
                  }
                  return
              }
              let range = 5..<data.count
              let newData = data.subdata(in: range)
              let decoder = JSONDecoder()
            
              do {
                 let requestObject = try decoder.decode(UserData.self, from: newData)
                    
                self.userData = requestObject
                      completionHandler(true, nil)
                  
                
              } catch {
                    completionHandler(true, error.localizedDescription)
                  
              }
            print(String(data: newData, encoding: .utf8)!)
            
        })
            
          
          task.resume()
          
    }
     

    
    
    
    
    
         func postStudent(_ student: LoctationStudents, completionHandlerPost: @escaping (_ success: Bool, _ error: String?) -> Void) {
                
         
                
                var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
                request.httpMethod = "POST"
                request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
                request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = "{\"uniqueKey\": \"\(String(describing: locationStudent?.uniqueKey))\", \"firstName\": \"\(String(describing: userData?.firstName))\", \"lastName\": \"\(String(describing: userData?.lastName))\",\"mapString\": \"\(String(describing: locationStudent?.mapString))\", \"mediaURL\": \"\(String(describing: locationStudent?.mediaURL))\",\"latitude\": \(String(describing: locationStudent?.latitude)), \"longitude\": \(String(describing: locationStudent?.longitude))}".data(using: .utf8)
            
                let session = URLSession.shared
                let task = session.dataTask(with: request) { data, response,
                    error in
                    if error != nil { // Handle error…
                        completionHandlerPost(false, error?.localizedDescription)
                        return
                    }
                    guard let data = data else {
                        completionHandlerPost(false, error?.localizedDescription)
                        return
                    }
                    guard let status = (response as? HTTPURLResponse)?.statusCode, status >= 200 && status <= 399 else {
                        completionHandlerPost(false, error?.localizedDescription)
                        return
                    }
                    do {
                        let decoder = JSONDecoder()
                        let decodedData = try! decoder.decode(LoctationStudents.self, from: data)
                        completionHandlerPost(true, nil)
                    } catch let error {
                        print(error.localizedDescription)
                        return
                    }
                    print(String(data: data, encoding: .utf8)!)
                }
                task.resume()
            }
}
 



/*func sendInformation(_ student: Result){
    var newStudent = LoctationStudents.self as! Result
                   newStudent.uniqueKey = student.uniqueKey
                   newStudent.firstName = student.firstName
                   newStudent.lastName = student.lastName
                   newStudent.mapString = student.mapString
                   newStudent.mediaURL = student.mediaURL
                   newStudent.longitude = student.longitude
                   newStudent.latitude = student.latitude
                LocationStudentMapViewController.postStudent(newStudent) { (success, errorMessage) in
                if success {
                           DispatchQueue.main.async {
                               self.navigationController?.popToRootViewController(animated: true)
                           }
                       } else {
                           DispatchQueue.main.async {
                             
                           }
                       }
    }*/




func logout(completion: @escaping () -> Void) {
    
    var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session/\(ViewController.finishedSession?.session.expiration ?? "")")!)
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
      return
  }
  let range = (5..<data!.count)
  let newData = data?.subdata(in: range) /* subset response data! */
  print(String(data: newData!, encoding: .utf8)!)
 completion()
}
task.resume()
}


  

  
