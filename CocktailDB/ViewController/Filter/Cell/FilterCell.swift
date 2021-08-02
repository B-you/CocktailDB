//
//  FilterCell.swift
//  CocktailDB
//
//  Created by mac on 31/07/21.
//

import UIKit

class FilterCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnCheck: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        btnCheck.setImage(UIImage(named: "check"), for: .selected)
        btnCheck.setImage(UIImage(), for: .normal)
        
        lblName.font = UIFont(name: FONT_ROBOTO_MEDIUM, size: 16.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
