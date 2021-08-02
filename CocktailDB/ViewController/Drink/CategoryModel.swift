//
//  CategoryModel.swift
//  CocktailDB
//
//  Created by mac on 31/07/21.
//

import UIKit

class CategoryModel: NSObject {
    var strCategory: String = ""
    var arrDrink = [DrinkModel]()
    var isSelected: Bool = false
    
    func setData(dict : NSDictionary)  {
        strCategory = dict.object_forKeyWithValidationForClass_String("strCategory")
    }
}


class DrinkModel: NSObject {
    var idDrink: String = ""
    var strDrink: String = ""
    var strDrinkThumb: String = ""
    
    func setData(dict : NSDictionary)  {
        idDrink = dict.object_forKeyWithValidationForClass_String("idDrink")
        strDrink = dict.object_forKeyWithValidationForClass_String("strDrink")
        strDrinkThumb = dict.object_forKeyWithValidationForClass_String("strDrinkThumb")
    }
}
