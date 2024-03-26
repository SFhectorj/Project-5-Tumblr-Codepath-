//
//  TableViewCell.swift
//  ios101-project5-tumblr
//
//  Created by Hector J. Baeza on 3/24/24.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var rightLabel: UILabel!
    
    @IBOutlet weak var leftImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }

}
