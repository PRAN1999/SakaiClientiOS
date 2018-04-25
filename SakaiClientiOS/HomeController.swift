//
//  HomeController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/23/18.

import Foundation
import UIKit
import Alamofire
import MaterialComponents.MaterialCollections

class HomeController: UIViewController, UIScrollViewDelegate {
    let appBar = MDCAppBar()
    
    @IBOutlet weak var scrollView: UIScrollView!
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.addChildViewController(appBar.headerViewController)
    }
    
    //Resets Alamofire default session on initial view load
    //Temporary measure for debugging purposes - 4/24/18 - PN
    override func viewDidLoad() {
        Alamofire.SessionManager.default.session.reset{}
        appBar.headerViewController.headerView.backgroundColor = UIColor(red: 1.0, green: 0.1, blue: 0.1, alpha: 1.0)
        appBar.navigationBar.tintColor = UIColor.black
        
        appBar.headerViewController.view.frame = view.bounds
        view.addSubview(appBar.headerViewController.view)
        appBar.headerViewController.didMove(toParentViewController: self)
        
        appBar.headerViewController.headerView.trackingScrollView = scrollView
        scrollView.delegate = appBar.headerViewController
        appBar.addSubviewsToParent()
        appBar.navigationBar.observe(navigationItem)
        
        title = "Sakai Client"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    //Print cookies for debugging purposes - 4/24/18 - PN
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Cookies here\n")
        let cookies:[HTTPCookie]? = HTTPCookieStorage.shared.cookies!
        for cookie in cookies! {
            print(cookie)
            print("\n")
        }
    }
    
    //Store all HTTP cookies in Alamofire default configration and make GET request
    @IBAction func makeReq(_ sender: Any) {
        let cookies:[HTTPCookie]? = HTTPCookieStorage.shared.cookies!
        for cookie in cookies! {
            Alamofire.SessionManager.default.session.configuration.httpCookieStorage?.setCookie(cookie)
        }
        
        let afManager:SessionManager = Alamofire.SessionManager.default
        afManager.request("https://sakai.rutgers.edu/direct/session/current.json", method: .get).validate().responseJSON { response in
            print("Response: \(String(describing: response.response))")
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
        }
    }
    
    //Invalidate user session by resetting Alamofire default session
    @IBAction func logout(_ sender: Any) {
        Alamofire.SessionManager.default.session.reset{
            print("reset logout")
        }
    }
    
    //Invalidate session when segueing to LoginViewController
    //Temporary measure for debugging purposes - 4/24/18 - PN
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Segue initiation")
        Alamofire.SessionManager.default.session.reset {
            print("reset segue")
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(1)
        if scrollView == appBar.headerViewController.headerView.trackingScrollView {
            appBar.headerViewController.headerView.trackingScrollDidScroll()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print(2)
        if scrollView == appBar.headerViewController.headerView.trackingScrollView {
            appBar.headerViewController.headerView.trackingScrollDidEndDecelerating()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print(3)
        let headerView = appBar.headerViewController.headerView
        if scrollView == headerView.trackingScrollView {
            headerView.trackingScrollDidEndDraggingWillDecelerate(decelerate)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print(4)
        let headerView = appBar.headerViewController.headerView
        if scrollView == headerView.trackingScrollView {
            headerView.trackingScrollWillEndDragging(withVelocity: velocity, targetContentOffset: targetContentOffset)
        }
    }
}
