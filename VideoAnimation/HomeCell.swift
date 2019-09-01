//
//  HomeCell.swift
//  VideoAnimation
//
//  Created by Yogendra Tandel on 01/09/19.
//  Copyright © 2019 Yogendra Tandel. All rights reserved.
//

import UIKit

class HomeCell: UITableViewCell {
    
    @IBOutlet weak var img_Movie: UIImageView!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_Desc: UILabel!
    @IBOutlet weak var lbl_Duration: UILabel!
    @IBOutlet weak var btn_Play: UIButton!
    @IBOutlet weak var imhMovieHeight: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateHomeCell(){
        
    }
    
}
