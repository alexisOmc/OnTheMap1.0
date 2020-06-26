//
//  ViewController.swift
//  OnTheMap
//
//  Created by Alexis Omar Marquez Castillo on 07/05/20.
//  Copyright © 2020 udacity. All rights reserved.
//

import UIKit
import Foundation


class ViewController: UIViewController, UITextFieldDelegate {
    
    enum Result <T> {
        case Success(T)
        case Error(String)
    }
        var window: UIWindow?
    
    
   static var finishedSession : Seession?
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    

    @IBOutlet weak var singUpButtom: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
         
        
        txtEmail.delegate = self
        txtPassword.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
        @IBAction func loginUser(_ sender: Any) {
            
        if isValidEmail(txtEmail.text!) == true {
            
            login(email: txtEmail.text!, password: txtPassword.text!) { (response) in
                switch response {
                case .Success( _):
                    
                        DispatchQueue.main.async{
                           
                            //pásalo de pantalla
                            if let tabbar = (self.storyboard?.instantiateViewController(withIdentifier: "miTabBar") as? UITabBarController) {
                                tabbar.modalPresentationStyle = .fullScreen
                                self.present(tabbar, animated: true, completion: nil)
                                
                        }
                    }
                case .Error(let error):
                      DispatchQueue.main.async {
                                                     
                                 let alert = UIAlertController(title: "Alert", message: "Invalid credentials", preferredStyle: .alert)
                         let ok = UIAlertAction(title: "ok", style: .default, handler: nil)
                         alert.addAction(ok)
                             self.present(alert, animated: true, completion: nil)
                                 }
                }
            }
        } else {
            
            }
    }
                
 
        
    func login(email: String, password: String, completion:@escaping (Result<Seession>)->Void){
       
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in

               
                let range = (5..<data!.count)
                let newData = data?.subdata(in: range) /* subset response data! */
                print(String(data: newData!, encoding: .utf8)!)
                
                                let session = try?  JSONDecoder().decode(Seession.self, from: newData!)
            
                
                               if let successSession = session {
                                completion(.Success(successSession))
                                ViewController.self.finishedSession = successSession
                                
                               } else {
                                   completion(.Error(error?.localizedDescription ?? ""))
                               }

                }
        task.resume()
            
            
            }

        
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
        
         }
  func textFieldDidBeginEditing(_ textField: UITextField) {
         
         if textField == txtEmail {
             txtEmail.text = ""
             
         } else if textField == txtPassword {
             txtPassword.text = ""
              self.view.frame.origin.y = -150 // Move view 150 points upward
         }
  
     }
     func textFieldDidEndEditing(_ textField: UITextField) {
           self.view.frame.origin.y = 0
        
        }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
   
    @IBAction func signup(_ sender: Any) {
        guard let url = URL(string: "https://www.udacity.com/account/auth#!/signup") else {
                   return
               }
               UIApplication.shared.open(url, options: [:], completionHandler: nil)
           }
    
        
     
    }



