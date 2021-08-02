//
//  DrinkCell.swift
//  CocktailDB
//
//  Created by mac on 31/07/21.
//

import UIKit

class DrinkCell: UITableViewCell {

    @IBOutlet weak var viewSeperator: UIView!
    @IBOutlet weak var imgDrink: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblName.font = UIFont(name: FONT_ROBOTO_MEDIUM, size: 16)
    }
    
    func setDrinkData(model: DrinkModel) {
        self.lblName.text = model.strDrink
        let imageURL = URL(string: model.strDrinkThumb)
        self.indicator.isHidden = false
        self.imgDrink.sd_setImage(with: imageURL, placeholderImage: UIImage(), options: .refreshCached){ (img, error, type, url) in
            self.indicator.isHidden = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
