
import Foundation
import UIKit

//MARK: - GENERAL
let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
let ServiceManager = AIServiceManager.sharedManager
let APP_NAME = ""

//MARK: - MANAGERS
let storyBoard = UIStoryboard(name: "Main", bundle: nil)

//MARK: - APP SPECIFIC

func getStringFromDictionary(_ dict:AnyObject) -> String{
	var strJson = ""
	do {
		let data = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
		strJson = String(data: data, encoding: String.Encoding.utf8)!
	} catch let error as NSError {
		print("json error: \(error.localizedDescription)")
	}
	return strJson
}


//MARK: - IMAGE
func ImageNamed(_ name:String) -> UIImage?{
	return UIImage(named: name)
}

//MARK: - COLORS
public func RGBCOLOR(_ r: CGFloat, g: CGFloat , b: CGFloat) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
}

public func RGBCOLOR(_ r: CGFloat, g: CGFloat , b: CGFloat, alpha: CGFloat) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alpha)
}

let APP_NAVIGATION_COLOR  = RGBCOLOR(248, g:248, b:248, alpha: 0.82)
let APP_SEPERATOR_COLOR   = RGBCOLOR(216, g:216, b:216)
let APP_GrayBG_COLOR      = RGBCOLOR(239, g:239, b:244)
let APP_DARKGRAY_COLOR    = RGBCOLOR(109, g:109, b:114)

//MARK: - FONTS
let FONT_SF_REGULAR    = "SFProText-Regular"
let FONT_SF_SEMIBOLD   = "SFProText-Semibold"
let FONT_SF_BOLD       = "SFProText-Bold"
let FONT_SF_MEDIUM     = "SFProText-Medium"
let FONT_ROBOTO_MEDIUM = "Roboto-Medium"


// MARK: - USERDEFAULTS
func setUserDefaultValues(_ key : String , value : String){
    let userDefault : UserDefaults = UserDefaults.standard
    userDefault.set(value, forKey: key)
    userDefault.synchronize()
}

func getUserDefaultValue(_ key : String) -> String{
    let userDefault : UserDefaults = UserDefaults.standard
    var value : String = ""
    if userDefault.value(forKey: key) != nil{
        value = userDefault.value(forKey: key) as! String
    }
    return value
}
