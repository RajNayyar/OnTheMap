//
//  udacityUser.swift
//  On the Map beta
//
//  Created by Rajpreet on 16/01/18.
//  Copyright © 2018 Rajpreet. All rights reserved.
//

import UIKit
class udacityUser: NSObject {
    static var firstname: String?
    static var lastname: String?
    static var sessionid: String?
    static var accountid: String?
    static var sharedSession = URLSession.shared
    class func sharedInstance() -> udacityUser {
        struct Singleton {
            static var sharedInstance = udacityUser()
        }
        return Singleton.sharedInstance
    }
    func authentication(username: String, password: String, completionHandlerForAuth: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
        let _ = newSession(udacityDirectConstants.apiSessionUrl , username: username, password: password) { (result, success, error) in
            
            guard let _ = result else {
                completionHandlerForAuth(false, "Please Check Your Network Connection")
                return
            }
        guard let session = result?["session"],
                let sessionId = session["id"] as? String,
                let user = result?["account"],
                let userId = user["key"] as? String else {
                    print("Error")
                    completionHandlerForAuth(false, "Enter the Correct Credentials.")
                    return
            }
            udacityUser.sessionid = sessionId
            udacityUser.accountid = userId
            let _ = self.getData(completionHandlerUser: { (result, success, error) in
                guard let user = result?["user"] else {
                    return
                }
                
                guard let firstName = user["first_name"] as? String, let lastName = user["last_name"] as? String else {
                    return
                }
                udacityUser.firstname = firstName as String?
                udacityUser.lastname = lastName as String?
            }
        )
            print("authentication working")
            completionHandlerForAuth(true, nil)}
    }
    
    func getData(completionHandlerUser: @escaping (_ result: [String:AnyObject]?, _ success: Bool, _ error: String?) -> Void) {
        
        let request = NSMutableURLRequest(url: URL(string: "\(udacityDirectConstants.apiUsernameUrl)\(udacityUser.accountid!)")!)
        
        let task = udacityUser.sharedSession.dataTask(with: request as URLRequest) { data, response, error in
            
            guard let _ = data else {
                completionHandlerUser(nil, false, "Please check your internet connection!")
                return
            }
            self.errorHandler(data, response, error as NSError?, completionHandler:  completionHandlerUser)
            let newData = data?.subdata(in: Range(uncheckedBounds: (5, data!.count)))
            self.convertData(newData!, convertedData: completionHandlerUser)
        }
        print("getData working")
        task.resume()
    }
    
    func newSession(_ urlPath: String, username: String, password: String, completionHandler: @escaping (_ result: [String:AnyObject]?, _ success: Bool, _ error: String?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: URL(string: urlPath)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print(request)
        let jsonDict: [String: Any] = [
            "udacity": [
                "username": username,
                "password": password
            ]
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted)
        request.httpBody = jsonData
        
        let task = udacityUser.sharedSession.dataTask(with: request as URLRequest) { data, response, error in
            
            guard let _ = data else {
                self.errorHandler(data, response, error as NSError?, completionHandler:  completionHandler)
                return
            }
            
            let newData = data?.subdata(in: Range(uncheckedBounds: (5, data!.count)))
            self.convertData(newData!, convertedData: completionHandler)
        }
        print("new session working")
        task.resume()
        return task
    }
    private func convertData(_ data: Data, convertedData: (_ result: [String:AnyObject]?, _ success: Bool, _ error: String?) -> Void) {
        let parsedResult: AnyObject!
        
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject?  ///
        } catch {
            convertedData(nil, false, "There was an error parsing the JSON")
            return
        }
        convertedData(parsedResult as? [String:AnyObject], true, nil)
    }

    func errorHandler(_ data: Data?, _ response: URLResponse?, _ error: NSError?, completionHandler: @escaping (_ result: [String:AnyObject]?, _ success: Bool, _ error: String?) -> Void) {
        
        guard (error == nil) else {
            completionHandler(nil, false, "ERROR")
            return
        }
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
            completionHandler(nil, false, "Please Check Your network connection")
            return
        }
        
        guard let _ = data else {
            completionHandler(nil, false, "No Data Found.")
            return
        }
    }
    func endUserSession(completionHandlerForDeleteSession: @escaping (_ success: Bool, _ error: String?) -> Void) {
        let _ = delete{ (result, success, error) in
            if success {
                completionHandlerForDeleteSession(true, nil)
            } else {
                completionHandlerForDeleteSession(false, error)
            }
        }
    }
    func delete(completionHandlerdelete: @escaping (_ result: [String:AnyObject]?, _ success: Bool, _ error: String?) -> Void) -> URLSessionDataTask {
        let request = NSMutableURLRequest(url: URL(string:  udacityDirectConstants.apiSessionUrl)!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = udacityUser.sharedSession.dataTask(with: request as URLRequest) { data, response, error in
            guard let _ = data else {
                self.errorHandler(data, response, error as NSError?, completionHandler: completionHandlerdelete)
                return
            }
            self.errorHandler(data, response, error as NSError?, completionHandler: completionHandlerdelete)
            let newData = data?.subdata(in: Range(uncheckedBounds: (5, data!.count)))
            self.convertData(newData!, convertedData: completionHandlerdelete)
        }
        task.resume()
        
        return task
    }
    
}


