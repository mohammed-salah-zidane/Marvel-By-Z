//
//  UIImageView.swift
//  Marvel
//
//  Created by prog_zidane on 12/1/19.
//  Copyright © 2019 prog_zidane. All rights reserved.
//

import Foundation
import UIKit
import Nuke

extension UIImageView{
    convenience init(assetName : String, scale : UIView.ContentMode = .scaleAspectFit){
        self.init(image : UIImage(named: assetName))
        contentMode = scale
    }
    func nuke(url : String?,placeHolder : String = "",_ completion: @escaping(_ status:Bool)->()){
        let options = ImageLoadingOptions(
            placeholder: UIImage(named: placeHolder),
            transition: .fadeIn(duration: 0.5),
            contentModes: .init(
                success: .scaleAspectFill,
                failure: .scaleAspectFill,
                placeholder: .scaleAspectFill
            )
        )
        if let URL = URL(string: url!) {
            DispatchQueue.main.async {
                Nuke.loadImage(with: ImageRequest(url: URL), options: options, into: self, progress: nil) { (result) in
                    switch result{
                    case .success:
                        completion(true)
                    case .failure:
                        completion(false)
                        //print(error)
                    }
                }
            }
            
        }
    }
    
}
