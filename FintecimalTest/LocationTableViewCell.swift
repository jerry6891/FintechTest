//
//  LocationTableViewCell.swift
//  FintecimalTest
//
//  Created by Jerry Lozano on 5/11/21.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var streetNameLabel: UILabel!
    @IBOutlet weak var suburbPlaceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
