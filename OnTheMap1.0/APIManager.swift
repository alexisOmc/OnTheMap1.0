//
//  APIManager.swift
//  OnTheMap1.0
//
//  Created by Alexis Omar Marquez Castillo on 03/08/20.
//  Copyright © 2020 udacity. All rights reserved.
//

import UIKit

class APIManager: NSObject {
    enum Result<T> {
          case Success(T)
          case Error(String)
      }
    var firstName : String?
    var lastName : String?
    static let sharedInstance = APIManager()
    
    func getStudentsLocations(completion:@escaping (Result<LoctationStudents>)->Void){
         
         let urlString = "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100&order=-updatedAt"
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
    
    
    
}
