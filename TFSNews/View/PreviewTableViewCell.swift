//
//  PreviewTableViewCell.swift
//  TFSNews
//
//  Created by SHREDDING on 04.02.2023.
//

import UIKit

class PreviewTableViewCell: UITableViewCell {
    @IBOutlet weak var titleOutlet: UILabel!
    
    @IBOutlet weak var numberOfVisit: UILabel!
    @IBOutlet weak var imageOutlet: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
