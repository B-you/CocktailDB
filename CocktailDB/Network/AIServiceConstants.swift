
import Foundation

//MARK:- BASE URL
let URL_BASE                            = "https://www.thecocktaildb.com/api/json/v1/1"

let API_TIME_OUT_INTERVAL = 25

let URL_CATEGORY_LIST                        = getFullUrl("/list.php?c=list")
let URL_DRINKBY_CATEGORY                     = getFullUrl("/filter.php?c=")

//MARK:- FULL URL
func getFullUrl(_ urlEndPoint : String) -> String {
    return URL_BASE + urlEndPoint
}


