//
//  CharacterCell.swift
//  Marvel
//
//  Created by prog_zidane on 12/1/19.
//  Copyright © 2019 prog_zidane. All rights reserved.
//

import UIKit

class CharacterCell: UITableViewCell {
    
    @IBOutlet weak var charcterNameLabel: UILabel!
    @IBOutlet weak var charcterImageView: UIImageView!
    
    var marvelCharacter:MarvelCharacter?{
        didSet{
            //MARK:- load image
            DispatchQueue.main.async { 
                self.charcterImageView.nuke(url: self.marvelCharacter?.thumbnail!.url, { [weak self] succss  in
                    guard let self = self else {return}
                    if !succss {
                        //when fail to load image assign no available image
                        self.charcterImageView.image = #imageLiteral(resourceName: "image_not_available")
                    }
                })
                self.charcterNameLabel.text = self.marvelCharacter?.name
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
