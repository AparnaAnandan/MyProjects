//
//  NewsListTableViewCell.swift
//  TheGuardian
//
//  Created by Aparna A on 14/09/21.
//

import UIKit

class NewsListTableViewCell: UITableViewCell {
   
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var thumbnailImaage: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
