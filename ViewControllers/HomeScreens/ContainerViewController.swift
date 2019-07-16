//
//  ContainerViewController.swift
//  ODDS-Driver
//
//  Created by Mayur iMac on 15/03/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit

class ContainerViewController: BaseViewController {
 @IBOutlet var viewHomeMyJobsBTN: UIView!
    @IBOutlet weak var scrollObject: UIScrollView!
    
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnMyJobs: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        btnHome.setTitle("Home".localized, for: .normal)
        btnMyJobs.setTitle("My Jobs".localized, for: .normal)

        // Do any additional setup after loading the view.
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setNavBarWithMenuORBack(Title: "Home".localized, LetfBtn: kIconMenu, IsNeedRightButton: true, isTranslucent: false)
    }

    @IBAction func btnHome(_ sender: UIButton) {
        self.scrollToPage(page: 0, animated: true)
     }

    @IBAction func btnMyJob(_ sender: UIButton)
    {
        self.scrollToPage(page: 1, animated: true)
     }


    func scrollToPage(page: Int, animated: Bool) {
        var frame: CGRect = self.scrollObject.frame
        frame.origin.x = frame.size.width * CGFloat(page)
        frame.origin.y = 0
        self.scrollObject.scrollRectToVisible(frame, animated: animated)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
