//
//  ViewController.swift
//  InternBCGDV
//
//  Created by Priyanka Gyawali on 8/9/19.
//  Copyright © 2019 Priyanka Gyawali. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
   
    
    @IBAction func submitAction(sender: UIButton) {
      
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        let parameters = ["name": "priyanka gyawali", "email": "priyanka.gyawali1@gmail.com"] as [String : String]
         //create the url with URL
        let url = URL(string: "https://interns.bcgdvsydney.com/api/v1/key")!

        //create the session object
        let session = URLSession.shared
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        //set http method as GET
        request.httpMethod = "GET"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
   
        //create dataTask using the session object to send data to the server
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            
            guard error == nil else {
                return
            }
                
            guard let data = data else {
                return
            }
             //create json object from data
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    guard let key = json["key"] as? String else {return}
                    guard let expirydate = json["expires"] as? String else {return}
                   // print(key)
                   // print(expirydate)
                    //add key to the url
                    let postUrl = URL(string: "https://interns.bcgdvsydney.com/api/v1/submit?apiKey=" + key)!
                    var request = URLRequest(url: postUrl)
                    //use http method post
                    request.httpMethod = "POST"
                    do {
                        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                    } catch let error {
                        print(error.localizedDescription)
                    }
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.addValue("application/json", forHTTPHeaderField: "Accept")
                    request.addValue(key, forHTTPHeaderField: "Authorization")
                    request.addValue(expirydate, forHTTPHeaderField: "Authorization")
                    
                    let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                        
                        guard error == nil else {
                            return
                        }
                        
                        guard let data = data else {
                            return
                        }
                        
                        do {
                            //create json object from data
                            if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                                print("json \(json)")
                                // send json result to label UI
                                if let result = json["error"] as? String {
                                    DispatchQueue.main.async{
                                        self.resultLabel.text = result
                                    }
                                }
                                if let result = json["name"] as? String {
                                    DispatchQueue.main.async{
                                        self.resultLabel.text = result
                                    }
                                }
                                if let result = json["email"] as? String {
                                    DispatchQueue.main.async{
                                        self.emailLabel.text = result
                                    }
                                }
                            
                            }
                        } catch let error {
                            print(error.localizedDescription)
                        }
                    })
                    task.resume()
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
}
