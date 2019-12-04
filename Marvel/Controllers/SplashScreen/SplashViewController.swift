//
//  SplashViewController.swift
//  Find On Flicker
//
//  Created by prog_zidane on 11/27/19.
//  Copyright © 2019 prog_zidane. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var splachActivityIndicator: UIActivityIndicatorView!
   
    //LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Mark:- Run Activity And Navigate to next ViewController
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.splachActivityIndicator.stopAnimating()
            self.splachActivityIndicator.isHidden = true
            self.showHomeScreen()
        }
    }
    //Mark:- Change Status Bar tint color
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}
extension SplashViewController {
    func showHomeScreen(){
        NavigationManager.navigateToHomeScreen(self)
    }
}
