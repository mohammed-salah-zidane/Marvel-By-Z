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
            DispatchQueue.main.async {
                //MARK:- load image
                self.resultImageView.nuke(url: self.marvelCharacter?.thumbnail!.url, { [weak self] succss  in
                    guard let self = self else {return}
                    if !succss {
                        //when fail to load image assign no available image
                        self.resultImageView.image = #imageLiteral(resourceName: "image_not_available")
                    }
                })
                self.resultNameLabel.text = self.marvelCharacter?.name
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
}
