//
//  AppDelegate.swift
//  Marvel
//
//  Created by prog_zidane on 12/1/19.
//  Copyright © 2019 prog_zidane. All rights reserved.
//

import UIKit
import Nuke
import GSMessages
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        configGSM()
        configImagesCaching()
        return true
    }

}

extension AppDelegate{
    
    //MARK: - configure Notification Messages
    func configGSM(){
        
        GSMessage.successBackgroundColor = UIColor(red: 142.0/255, green: 183.0/255, blue: 64.0/255,  alpha: 0.95)
        GSMessage.warningBackgroundColor = UIColor(red: 230.0/255, green: 189.0/255, blue: 1.0/255,   alpha: 0.95)
        GSMessage.errorBackgroundColor   = UIColor(red: 219.0/255, green: 36.0/255,  blue: 27.0/255,  alpha: 0.70)
        GSMessage.infoBackgroundColor    = UIColor(red: 44.0/255,  green: 187.0/255, blue: 255.0/255, alpha: 0.90)
    }
    //MARK :- for chache images configurations
    func configImagesCaching(){
        // 1
        DataLoader.sharedUrlCache.diskCapacity = 0
        
        let pipeline = ImagePipeline {
            // 2
            let dataCache = try! DataCache(name: "com.m.s.zidane.com.Marvel")
            // 3
            dataCache.sizeLimit = 200 * 1024 * 1024
            // 4
            $0.dataCache = dataCache
        }
        // 5
        ImagePipeline.shared = pipeline
    }
    
}

