//
//  File.swift
//  OnTheMap1.0
//
//  Created by Alexis Omar Marquez Castillo on 07/07/20.
//  Copyright © 2020 udacity. All rights reserved.
//

import Foundation
import UIKit

class Alerta {
    
    static func showMessage(title: String, msg: String, `on` controller: UIViewController) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
    
}
