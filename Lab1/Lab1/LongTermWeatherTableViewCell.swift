//
//  LongTermWeatherTableViewCell.swift
//  Lab1
//
//  Created by Karol Perec on 17/12/2019.
//  Copyright © 2019 Karol Perec. All rights reserved.
//

import UIKit

class LongTermWeatherTableViewCell: UITableViewCell {
    @IBOutlet weak var dayImage: UIImageView!
    @IBOutlet weak var dayDate: UILabel!
    @IBOutlet weak var dayTemperature: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var wind: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
