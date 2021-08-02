
import Alamofire
import UIKit

class AIServiceManager: NSObject {
    
    static let sharedManager : AIServiceManager = {
        let instance = AIServiceManager()
        return instance
    }()
    
    // MARK: - ERROR HANDLING
    
    func handleError(_ errorToHandle : NSError){
        
        if(errorToHandle.domain == CUSTOM_ERROR_DOMAIN)    {
            displayAlertWithMessage("Something went wrong.")
        }else if(errorToHandle.code == -1009){
            displayAlertWithMessage("We are unable to connect to the server. Please check your internet connection and try again.")
        }else{
            if(errorToHandle.code == -999){
                return
            }
            displayAlertWithMessage(errorToHandle.localizedDescription)
        }
    }
    
    // MARK: - ************* COMMON API METHOD **************
    
    // GET
    func callGetApi(_ url : String , completionHandler : @escaping (AFDataResponse<Any>) -> ())
    {
        if IS_INTERNET_AVAILABLE() {
            let url = URL(string: url)!
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.get.rawValue
            request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            request.timeoutInterval = 30
            AF.request(request).responseJSON(completionHandler: completionHandler)
        }else{
            SHOW_INTERNET_ALERT()
        }
        
    }
    
    func callPostApi(_ url : String, params : [String : AnyObject]?, completionHandler :@escaping (AFDataResponse<Any>) -> ()) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " ,
            "Accept" : "application/json"
        ]
        
        print("*******************************")
        print("URL: " , url)
        print("Param: " , params! )
        print("Header: ", headers)
        print("*******************************")
        
        if IS_INTERNET_AVAILABLE() {
            AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers, interceptor: nil, requestModifier: { $0.timeoutInterval = TimeInterval(API_TIME_OUT_INTERVAL) }).responseJSON(completionHandler: completionHandler)
        } else {
            SHOW_INTERNET_ALERT()
        }
    }
    
    func SHOW_INTERNET_ALERT(){
        displayAlertWithMessage("We are unable to connect to the server. Please check your internet connection and try again.")
    }
    
    func callPostApiWithouttoken(_ url : String, params : [String : AnyObject]?, completionHandler :@escaping (AFDataResponse<Any>) -> ()) {
        let headers: HTTPHeaders = []
        
        print("*******************************")
        print("URL : " , url)
        print("Param : " , params! )
        print("*******************************")
        
        if IS_INTERNET_AVAILABLE() {
            AF.request(url, method: .post, parameters: params, headers: headers).responseJSON(completionHandler: completionHandler)
        } else {
            SHOW_INTERNET_ALERT()
        }
    }
    
    // MARK: - ************* CATEGORY API **************
    func apiCategoryList(completetion : @escaping (_ isSuccess:Bool,_ dicJson:[NSDictionary]) -> Void){
        self.callGetApi(URL_CATEGORY_LIST) { (response) -> Void in
            switch response.result {
            case.success(let Json):
               
                let dictJson = Json as! NSDictionary
                print(dictJson)
                if let dicResp = dictJson.value(forKey: "drinks") as? [NSDictionary] {
                    completetion(true,dicResp)
                }else{
                    completetion(false,[NSDictionary]())
                }
            case.failure(let error):
                self.handleError(error as NSError)
                completetion(false,[NSDictionary]())
            }
        }
    }
    
    // MARK: - ************* CATEGORY DRINK API **************
    func apiCategoryDrinkList(strname: String, completetion : @escaping (_ isSuccess:Bool,_ dicJson:[NSDictionary]) -> Void){
        let strurl: String = URL_DRINKBY_CATEGORY + strname
        let urlString = strurl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        print(urlString)
        self.callGetApi(urlString) { (response) -> Void in
            switch response.result {
            case.success(let Json):
               
                let dictJson = Json as! NSDictionary
                print(dictJson)
                if let dicResp = dictJson.value(forKey: "drinks") as? [NSDictionary] {
                    completetion(true,dicResp)
                }else{
                    completetion(false,[NSDictionary]())
                }
            case.failure(let error):
                self.handleError(error as NSError)
                completetion(false,[NSDictionary]())
            }
        }
    }
}

