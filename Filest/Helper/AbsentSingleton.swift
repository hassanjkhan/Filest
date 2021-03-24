//
//  AbsentSingleton.swift
//  Filest
//
//  Created by Hassan Khan on 2021-03-21.
//  Copyright © 2021 Z-Lux. All rights reserved.
//

import Foundation

class AbsentSingleton {
    
    static let sharedInstance = AbsentSingleton(fromDate: .yesterday, toDate: .yesterday)
    
    var fromDate: Date
    var toDate: Date
    var to: [String]
    var description: String
    var lockedView : Bool
    //   /\  /\  /\  /\  /\  /\
    //  /  \/  \/  \/  \/  \/  \
    //  \  /\  /\  /\  /\  /\  /
    //   \/  \/  \/  \/  \/  \/
    
    private init(fromDate: Date, toDate: Date){
        self.fromDate = fromDate
        self.toDate = toDate
        self.to = Array.init()
        self.description = String.init()
        self.lockedView = false
    }
    
    class func getlockedView() -> Bool {
        return sharedInstance.lockedView
    }
    
    class func setlockedView(bool: Bool){
        sharedInstance.lockedView = bool
    }
    class func getfromDate() -> Date{
        return sharedInstance.fromDate
    }
    
    class func setfromDate(fromDate: Date){
        sharedInstance.fromDate = fromDate
    }
    
    class func gettoDate() -> Date{
        return sharedInstance.toDate
    }
    
    class func settoDate(toDate: Date){
        sharedInstance.toDate = toDate
    }
    
    class func addto(uid: String){
        if (uid.count > 0){
            sharedInstance.to.append(uid)
        }
        
    }
    
    class func getto() -> [String]{
        return sharedInstance.to.filter{$0 != ""}
    }
    
    class func removeto(uid: String){
        if sharedInstance.to.contains(uid){
            var i = 0
            for person in sharedInstance.to {
                if(person == uid){
                    sharedInstance.to.remove(at: i)
                } else {
                    i = i + 1
                }
            }
        }
        
    }
//    class func setto(to: [String]){
//        sharedInstance.to = to
//    }
    
    class func getdescription() -> String{
        return sharedInstance.description
    }
    
    class func setdescription(description: String){
        sharedInstance.description = description
    }
    
    class func refresh(){
        sharedInstance.fromDate =  .yesterday
        sharedInstance.toDate =  .yesterday
        sharedInstance.to = [String.init()]
        sharedInstance.description = String.init()
        sharedInstance.lockedView = false
        
    }
    
}
