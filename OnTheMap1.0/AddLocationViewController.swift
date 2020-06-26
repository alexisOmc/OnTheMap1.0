//
//  AddLocationViewController.swift
//  OnTheMap1.0
//
//  Created by Alexis Omar Marquez Castillo on 05/06/20.
//  Copyright © 2020 udacity. All rights reserved.
//

import UIKit

class AddLocationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var yourLocationTxtField: UITextField!
    @IBOutlet weak var webSideTxtField: UITextField!
    @IBOutlet weak var findLocationButtom: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    yourLocationTxtField.delegate = self
    webSideTxtField.delegate = self
    yourLocationTxtField.borderStyle = .roundedRect
    webSideTxtField.borderStyle = .roundedRect
    findLocationButtom.layer.cornerRadius = 5
       
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        
    }
    
    
}
