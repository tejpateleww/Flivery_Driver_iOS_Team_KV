//
//  webViewVC.swift
//  TiCKTOC-Driver
//
//  Created by Excelent iMac on 02/12/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import WebKit

class webViewVC: ParentViewController, WKNavigationDelegate {

    var headerName = String()
    var strURL = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

         UtilityClass.showACProgressHUD()
//
//         strURL = "https://www.tantaxitanzania.com/web/front/privacypolicy"

        let requestURL = URL(string: strURL)!
        let request = URLRequest(url: requestURL as URL)
        webView.load(request)
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
    
    // MARK: - Outlets
    @IBOutlet weak var webView: WKWebView!
    
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        UtilityClass.hideACProgressHUD()
        // Show Alert here.
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UtilityClass.hideACProgressHUD()
    }

}
