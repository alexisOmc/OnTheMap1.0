//
//  LocationViewCell.swift
//  OnTheMap1.0
//
//  Created by Alexis Omar Marquez Castillo on 11/06/20.
//  Copyright © 2020 udacity. All rights reserved.
//

import UIKit

class LocationViewCell: UITableViewCell {
    
    
    @IBOutlet weak var mediaUrl: UILabel!
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var imagePin: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
