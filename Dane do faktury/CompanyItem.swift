//
//  CompanyItem.swift
//  Dane do faktury
//
//  Created by Niżnik Piotr on 17/04/2018.
//  Copyright © 2018 Piotr Niznik. All rights reserved.
//

import Foundation

class CompanyItem : NSObject, NSCoding {
    
    var CompanyName: String!;
    var CompanyAddress: String!;
    var CompanyNIP: String!;
    var CompanyCarRegistrationNumber: String!;
    var CompanyRegon: String!
    
    required override init() {
        super.init()
    }
    
    required init(cName: String, cAddress: String) {
        CompanyName = cName
        CompanyAddress = cAddress
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        CompanyName = aDecoder.decodeObject(forKey: "CompanyName") as! String
        CompanyAddress = aDecoder.decodeObject(forKey: "CompanyAddress") as! String
        CompanyNIP = aDecoder.decodeObject(forKey: "CompanyNIP") as! String
        CompanyCarRegistrationNumber = aDecoder.decodeObject(forKey: "CompanyCarRegistrationNumber") as! String
        CompanyRegon = aDecoder.decodeObject(forKey: "CompanyRegon") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(CompanyName, forKey: "CompanyName")
        aCoder.encode(CompanyAddress, forKey: "CompanyAddress")
        aCoder.encode(CompanyNIP, forKey: "CompanyNIP")
        aCoder.encode(CompanyCarRegistrationNumber, forKey: "CompanyCarRegistrationNumber")
        aCoder.encode(CompanyRegon, forKey: "CompanyRegon")
    }
    
    
}
