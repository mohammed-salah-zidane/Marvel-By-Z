//
//  ResultsCell.swift
//  Marvel
//
//  Created by prog_zidane on 12/2/19.
//  Copyright © 2019 prog_zidane. All rights reserved.
//

import UIKit

class ResultsCell: UITableViewCell {

    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var resultNameLabel: UILabel!
    var marvelCharacter:MarvelCharacter?{
        didSet{
            resultImageView.nuke(url: self.marvelCharacter?.thumbnail!.url, {_ in})
            print((self.marvelCharacter?.thumbnail!.path!)! + "\(self.marvelCharacter!.thumbnail!.x_tension!)")
            resultNameLabel.text = self.marvelCharacter?.name
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()

        
    }
}
