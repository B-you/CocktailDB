
import UIKit
import Reachability

class AIReachabilityManager: NSObject {
    
    var reachability:Reachability!
    
    static let sharedManager : AIReachabilityManager = {
        let instance = AIReachabilityManager()
        return instance
    }()
    
    func isInternetAvailableForAllNetworks() -> Bool
    {
        if(self.reachability == nil){
            self.doSetupReachability()
            return self.reachability!.connection == .unavailable || reachability!.connection == .wifi || self.reachability!.connection == .cellular
        }else{
            return reachability!.connection == .unavailable || reachability!.connection == .wifi || reachability!.connection == .cellular
        }
    }
    
    func doSetupReachability() {
        do{
            let reachability = try Reachability()
            self.reachability = reachability
        }catch {
            
        }
        reachability.whenReachable = { reachability in
        }
        reachability.whenUnreachable = { reachability in
        }
        do {
            try reachability.startNotifier()
        }
        catch {
        }
    }
    deinit{
        reachability.stopNotifier()
        reachability = nil
    }
    
}

