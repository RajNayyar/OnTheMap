//
//  udacityUserData.swift
//  onTheMapBeta
//
//  Created by Rajpreet on 21/01/18.
//  Copyright © 2018 Rajpreet. All rights reserved.
//


import Foundation


struct studentData {
    
    class SharedData: NSObject {
        static let shared = SharedData()
        var studentsInformations = [studentData]()
    }

    
    var firstName: String?
    var lastName: String?
    var fullName: String?
    {return "\(String(describing: firstName)) \(String(describing: lastName))"}
    var uniqueKey: String?
    var latitude: Double?
    var longitude: Double?
    var mapString: String?
    var mediaURL: String?
    
    init(dictionary: [String:AnyObject]) {
        self.firstName = dictionary["firstName"] as? String
        self.lastName = dictionary["lastName"]  as? String
        self.uniqueKey = dictionary["uniqueKey"] as? String
        self.latitude = dictionary["latitude"]  as? Double
        self.longitude = dictionary["longitude"] as? Double
        self.mapString = dictionary["mapString"] as? String
        self.mediaURL = dictionary["mediaURL"]  as? String
    }
}


