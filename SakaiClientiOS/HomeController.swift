//
//  NewController.swift
//  web load
//
//  Created by Pranay Neelagiri on 4/23/18.
//  Copyright © 2018 MAGNUMIUM. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class HomeController: UIViewController {
    
    override func viewDidLoad() {
        HTTPCookieStorage.shared.cookies?.forEach(HTTPCookieStorage.shared.deleteCookie)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("Cookies here\n")
        let cookies:[HTTPCookie]? = HTTPCookieStorage.shared.cookies!
        for cookie in cookies! {
            print(cookie)
        }
    }
    
    
    @IBAction func makeReq(_ sender: Any) {
        Alamofire.request("https://sakai.rutgers.edu/direct/user/current.json").responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
    }
}
