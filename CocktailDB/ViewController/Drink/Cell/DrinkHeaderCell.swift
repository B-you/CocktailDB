//
//  DrinkHeaderCell.swift
//  CocktailDB
//
//  Created by mac on 31/07/21.
//

import UIKit

class DrinkHeaderCell: UITableViewCell {

    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        viewBg.backgroundColor = APP_GrayBG_COLOR
        lblName.textColor = APP_DARKGRAY_COLOR
        lblName.font = UIFont(name: FONT_SF_REGULAR, size: 13)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
