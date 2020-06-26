//
//  data.swift
//  OnTheMap1.0
//
//  Created by Alexis Omar Marquez Castillo on 12/06/20.
//  Copyright © 2020 udacity. All rights reserved.
//

import Foundation
class DataHandler {
    static let shared = DataHandler()
    
    func handleErrors(_ data: Data?, _ response: URLResponse?, _ error: NSError?, completionHandler: @escaping (_ result: [String:AnyObject]?, _ success: Bool, _ error: String?) -> Void) {
        
        guard (error == nil) else {
            completionHandler(nil, false, ConstantsUdacity.NetworkProblem)
            return
        }
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
            completionHandler(nil, false, ConstantsUdacity.IncorrectDetail)
            return
        }
        
        guard let _ = data else {
            completionHandler(nil, false, ConstantsUdacity.NoData)
            return
        }
    }
    
}
