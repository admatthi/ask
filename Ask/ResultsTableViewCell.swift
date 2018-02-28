//
//  ResultsTableViewCell.swift
//  Ask
//
//  Created by Alek Matthiessen on 2/18/18.
//  Copyright © 2018 AA Tech. All rights reserved.
//

import UIKit

class ResultsTableViewCell: UITableViewCell {

    @IBOutlet weak var campaigntitletext: UILabel!
    @IBOutlet weak var campaignyestext: UILabel!
    @IBOutlet weak var campaignnotext: UILabel!
    @IBOutlet weak var campaigntotaltext: UILabel!
    @IBOutlet weak var campaigncosttext: UILabel!
    
    @IBOutlet weak var contentimage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
