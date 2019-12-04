//
//  UIViewController.swift
//  Marvel
//
//  Created by prog_zidane on 12/1/19.
//  Copyright © 2019 prog_zidane. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func setupTitleIamge(){
        let image: UIImage = #imageLiteral(resourceName: "logo")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        imageView.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.navigationItem.titleView = imageView
    }

}
