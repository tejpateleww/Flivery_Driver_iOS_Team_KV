//
//  LegalWebView.swift
//  TanTaxi-Driver
//
//  Created by excellent Mac Mini on 30/10/18.
//  Copyright © 2018 Excellent Webworld. All rights reserved.
//

import UIKit
import WebKit

class LegalWebView: ParentViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    
    var headerName = String()
    var strURL = String()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.headerView?.lblTitle.text = "Support".localized
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UtilityClass.showACProgressHUD()
        //
//        strURL = "https://www.tantaxitanzania.com/web/front/termsconditions"
        
        //        let requestURL = URL(string: url)
        //        let request = URLRequest(url: requestURL! as URL)
        //        webView.loadRequest(request)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if headerName != "" {
            headerView?.lblTitle.text = headerName
        }
        
        let url = strURL
        
        let requestURL = URL(string: url)
        let request = URLRequest(url: requestURL! as URL)
        webView.load(request)
        
    }
    

    
    @IBAction func btnBack(_ sender: UIButton) {
//        self.navigationController?.popToViewController(LegalViewController, animated: true)
    }    
}




class termsConditionWebviewVc: ParentViewController, WKNavigationDelegate  {
    
    @IBOutlet weak var webView: WKWebView!
    
    var headerName = String()
    var strURL = String()
    
    // MARK: - Outlets
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UtilityClass.showACProgressHUD()
        //
        strURL = "https://www.tantaxitanzania.com/web/front/termsconditions"
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
       

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if headerName != "" {
            headerView?.lblTitle.text = headerName
        }
        
        let url = strURL
        
        let requestURL = URL(string: url)
        let request = URLRequest(url: requestURL! as URL)
        webView.load(request)
        
    }
    
    
    // MARK: - web view delegate method
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UtilityClass.hideACProgressHUD()
    }
    
    
}
