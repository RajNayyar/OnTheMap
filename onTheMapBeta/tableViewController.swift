//
//  tableViewController.swift
//  onTheMapBeta
//
//  Created by Rajpreet on 23/01/18.
//  Copyright © 2018 Rajpreet. All rights reserved.
//

import UIKit

class tableViewController: UITableViewController {
   

    @IBOutlet var tableViewOutlet: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async{
            self.list()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentData.Location.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell")! as! tableViewCell
        let user = studentData.Location[indexPath.row]
        let userName = "\(String(describing: user.fullName!))"
        print(userName)
        let range = userName.rangeOfCharacter(from: NSCharacterSet.letters)
        DispatchQueue.main.async {
            if range != nil {
                if user.firstName != nil && user.lastName != nil {
        
                        cell.nameLabel?.text = "\(user.firstName!) \(user.lastName!)"
                }
                else if user.firstName == nil && user.lastName != nil
                {
                  
                        cell.nameLabel?.text = "\(user.lastName!)"
                }
                else if user.firstName != nil && user.lastName == nil
                {
                        cell.nameLabel?.text = "\(user.firstName!)"}
                }
                    
                else {
                    cell.nameLabel!.text = "Anonymous"
                }
            
            if let mediaUrl = user.mediaURL {
                cell.websiteLabel!.text = mediaUrl
            }
            else
            {
                 cell.websiteLabel!.text = "Unknown"
            }
        }
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let app = UIApplication.shared
        let mediaUrl = studentData.Location[indexPath.row].mediaURL
        if let toOpen = mediaUrl {
            if VerifyUrl(urlString: toOpen) {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            } else {
                let alert = UIAlertController(title: "Error", message: "invalid URL", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func VerifyUrl(urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url  = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    func list() {
        parseUser.sharedInstance().showLocation{ (locations, success, error) in
            if success {
                DispatchQueue.main.async {
                    self.tableViewOutlet.reloadData()
                }
            }
        }
    }
    @IBAction func addNewPin(_ sender: Any) {
        let postController = storyboard?.instantiateViewController(withIdentifier: "post")
        present(postController! , animated: true, completion: nil)
    }


    
}
