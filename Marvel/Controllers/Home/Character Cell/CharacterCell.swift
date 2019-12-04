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
            charcterImageView.nuke(url: self.marvelCharacter?.thumbnail!.url, {_ in})
            print((self.marvelCharacter?.thumbnail!.path!)! + "\(self.marvelCharacter!.thumbnail!.x_tension!)")
            charcterNameLabel.text = self.marvelCharacter?.name
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
