//
//  AddLocationViewController.swift
//  OnTheMap1.0
//
//  Created by Alexis Omar Marquez Castillo on 05/06/20.
//  Copyright © 2020 udacity. All rights reserved.
//
import Foundation
import UIKit
import CoreLocation
var studentPin: StudentPin!
var lat: CLLocationDegrees?
var lon: CLLocationDegrees?
class AddLocationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var yourLocationTxtField: UITextField!
    @IBOutlet weak var webSideTxtField: UITextField!
    @IBOutlet weak var findLocationButtom: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
    
    var urlErrorMsg: String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yourLocationTxtField.delegate = self
        webSideTxtField.delegate = self
        yourLocationTxtField.borderStyle = .roundedRect
        webSideTxtField.borderStyle = .roundedRect
        findLocationButtom.layer.cornerRadius = 5
    }
    
    
    @IBAction func findLocationTapped(_ sender: Any) {
        
        self.setGeocodeIn(true)
        print("studentLocation text\(self.yourLocationTxtField.text!)")
        self.getCoordinate(addressString: self.yourLocationTxtField.text ?? "", completionHandler: { coordinate2D, error  in
            if error == nil {
                print("coordinate is \(coordinate2D)")
                lat = coordinate2D.latitude
                lon = coordinate2D.longitude
                
                //Check if the mediaURL is in correct format before performing Segue
                if self.isMediaURLFormat() {
                    studentPin = StudentPin(coordinate: coordinate2D, mapString: self.yourLocationTxtField.text ?? "", mediaURL:  self.webSideTxtField.text ?? "" )
                    
                    self.setGeocodeIn(false)
                    
                    self.performSegue(withIdentifier: "location", sender: nil)
                    
                } else {
                    self.setGeocodeIn(false)
                    Alerta.showMessage(title: "Incompatible URL Format", msg: self.urlErrorMsg, on: self)
                }
            }
            else {
                self.setGeocodeIn(false)
                Alerta.showMessage(title: "Couldn't Find Location", msg: error?.localizedDescription ?? "", on: self)
            }
        })
        
    }
    
    
    
    func isMediaURLFormat() -> Bool {
        //se debera empezar con 'https://'
        if let typedURL = self.webSideTxtField.text, !typedURL.isEmpty {
            
            if typedURL.starts(with: "https://") {
                
                //me regresara true si la Url funciona
                if verifyUrl(urlString: typedURL) { return true
                    
                } else {
                    urlErrorMsg = "The URL you provid does not work."
                    return false
                }
                
            } else {
                
                urlErrorMsg = "URL must begin with 'https://'"
                return false
                
            }
            
        } else {
            urlErrorMsg = "Please Add correct a Link (por favor añada un link correcto)."
            return false
        }
    }
    
    
    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    // geocoding
    func setGeocodeIn(_ geocodeIn: Bool) {
        if geocodeIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        
        findLocationButtom.isEnabled = !geocodeIn
    }
    
    
    func removeActivitiindicator(){
        activityIndicator.removeFromSuperview()
        activityIndicator = nil
    }
    
    //traduce la cadena en cordenadas
    func getCoordinate( addressString : String,
                        completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
            
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}









