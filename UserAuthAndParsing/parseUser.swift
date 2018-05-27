//
//  parseUser.swift
//  onTheMapBeta
//
//  Created by Rajpreet on 21/01/18.
//  Copyright © 2018 Rajpreet. All rights reserved.
//

import Foundation
class parseUser: NSObject {
    
    class func sharedInstance() -> parseUser {
        struct Singleton {
            static var sharedInstance = parseUser()
        }
        return Singleton.sharedInstance
    }
func getStudentLocations(completionHandlerForGetLocations: @escaping (_ result: [String:AnyObject]?, _ success: Bool, _ error: String?) -> Void) {
    
    let request = NSMutableURLRequest(url: URL(string: "\(udacityParsingConstants.APIUrl)/\(udacityParsingConstants.studentLocation)\(udacityParsingConstants.LimitAndOrder)")!)
    request.addValue(udacityParsingConstants.parseappId, forHTTPHeaderField: "X-Parse-Application-Id")
    request.addValue(udacityParsingConstants.RESTAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
    
    let session = udacityUser.sharedSession
    let task = session.dataTask(with: request as URLRequest) { data, response, error in
        
        guard let _ = data else {
            completionHandlerForGetLocations(nil, false, "Network Problem")
            return
        }
        
        self.errorHandler(data, response, error as NSError?, completionHandler: completionHandlerForGetLocations)
        
        self.parsing(data!, completionHandlerForConvertedData: completionHandlerForGetLocations)
    }
    
    task.resume()
}
  
    private func parsing(_ data: Data, completionHandlerForConvertedData: (_ result: [String:AnyObject]?, _ success: Bool, _ error: String?) -> Void) {
        let parsedResult: AnyObject!
        
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject?  //
        } catch {
            completionHandlerForConvertedData(nil, false, "There was an error parsing the JSON")
            return
        }
        print("workingggg")
        print(data)
        completionHandlerForConvertedData(parsedResult as? [String:AnyObject], true, nil)
    }
    
    func showLocation(completionHandler: @escaping (_ result : [studentData]? , _ success: Bool , _ error: String?) -> Void ) {
        parseUser.sharedInstance().getStudentLocations{(result, success, error) in
            if success {
                if let data = result!["results"] as AnyObject? {
                    studentData.Location.removeAll()
                    for result in data as! [AnyObject] {
                        let student = studentData(dictionary: result as! [String : AnyObject])
                        studentData.Location.append(student)
                    }
                    completionHandler(studentData.Location, true, nil)
                }
            }
            else{
                completionHandler(nil, false, error)
            }
        }
    }
    
    func postLocation(mapString: String, mediaUrl: String, latitude: Double, longitude: Double, completionHandlerForPostLocation: @escaping (_ result: [String:AnyObject]?, _ success: Bool,  _ error: String?) -> Void) {
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print("in data sdbvdbsjdzbjkvBDBSJHBbvhjvjvhvJGFTFHFHFH")
        
        
        
        
        let jsonDict: [String:Any] = [
            "uniqueKey": udacityUser.accountid!,
            "firstName": udacityUser.firstname!,
            "lastName": udacityUser.lastname!,
            "mapString": mapString,
            "mediaURL": mediaUrl,
            "latitude": latitude,
            "longitude": longitude
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted)
        print("in data sdbvdbsjdzbjkvBDBSJHBbvhjvjvhvJGFTFHFHFH")
        print(jsonData)
        request.httpBody = jsonData
        let session = udacityUser.sharedSession
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            guard let _ = data else {
                completionHandlerForPostLocation(nil, false, "Please Check Your Network Connection")
                return
            }
            self.errorHandler(data, response, error as NSError?, completionHandler: completionHandlerForPostLocation)
            self.parsing(data!, completionHandlerForConvertedData: completionHandlerForPostLocation)
        }
        task.resume()
    }
    
    func errorHandler(_ data: Data?, _ response: URLResponse?, _ error: NSError?, completionHandler: @escaping (_ result: [String:AnyObject]?, _ success: Bool, _ error: String?) -> Void) {
        
        guard (error == nil) else {
            completionHandler(nil, false, "Please Check Your Network Connection")
            return
        }
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
            completionHandler(nil, false, "Error Collecting Data from Server")
            return
        }
        
        guard let _ = data else {
            completionHandler(nil, false, "No Data Found.")
            return
        }
    }
}
