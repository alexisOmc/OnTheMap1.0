//
//  TableViewControllerList.swift
//  OnTheMap1.0
//
//  Created by Alexis Omar Marquez Castillo on 16/06/20.
//  Copyright © 2020 udacity. All rights reserved.
//

import UIKit

class TableViewControllerList: UIViewController {

      var result = [Result]()
     
       
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
           super.viewDidLoad()
           print("view did load")
           tableView.delegate = self
           tableView.dataSource = self
      
       }
   }

   extension TableViewControllerList: UITableViewDelegate, UITableViewDataSource {
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           // #warning Incomplete implementation, return the number of rows
           return result.count
        
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
           let cell = tableView.dequeueReusableCell(withIdentifier: "LocationViewCell") as! LocationViewCell
        
        let student = self.result[(indexPath).row]
        cell.locationName.text = "\(student.firstName)  \(student.lastName )"
           cell.mediaUrl.text = student.mediaURL
           return cell
       }
       
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           let url = self.result[(indexPath).row].mediaURL
           print("url is: \(String(describing: url))")
        if let url = URL(string: url )
           {
               UIApplication.shared.open(url)
           }
       }
   }
