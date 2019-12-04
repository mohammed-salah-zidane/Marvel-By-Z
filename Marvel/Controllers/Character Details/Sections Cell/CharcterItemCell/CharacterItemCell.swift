//
//  CharacterItemCell.swift
//  Marvel
//
//  Created by prog_zidane on 12/3/19.
//  Copyright © 2019 prog_zidane. All rights reserved.
//

import UIKit

class CharacterItemCell: UICollectionViewCell {

    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var characterImageView: UIImageView!
    
    var section:String?
    var item:Items?{
        didSet{
            
            var resourceType :ResourceType!
            if section == "COMICS"{
                resourceType = .comics(id: self.item!.id ?? 0)
            }else if section == "SERIES" {
                resourceType = .series(id: self.item!.id ?? 0 )
            
            }else if section == "STORIES"{
                resourceType = .stories(id: self.item!.id ?? 0)
            }else if section == "EVENTS"{
                resourceType = .events(id: self.item?.id ?? 0)
            }
            //print("comicn",self.item!.id)
            DispatchQueue.main.async {
                Router.shared.fetchImageUrl(resourceType: resourceType, { (success, url) in
                    if success {
                        print((self.item?.resourceURI!)!)
                        self.characterImageView.nuke(url:  url, {_ in})
                    }else {
                        self.characterImageView.image = #imageLiteral(resourceName: "image_not_available")
                    }
                })
            }
            characterNameLabel.text = self.item?.name
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
