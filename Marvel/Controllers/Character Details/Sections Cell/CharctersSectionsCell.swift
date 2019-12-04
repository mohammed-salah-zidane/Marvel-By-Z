//
//  CharctersSectionsCell.swift
//  Marvel
//
//  Created by prog_zidane on 12/2/19.
//  Copyright © 2019 prog_zidane. All rights reserved.
//

import UIKit

class CharctersSectionsCell: UITableViewCell {

    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var noDataText :String? {
        didSet{
            noDataLabel.text = self.noDataText
        }
    }
    var characters:[Items]?{
        didSet{
            self.collectionView.reloadData()
            if self.characters?.count == 0 {
                collectionView.isHidden = true
                noDataLabel.isHidden = false
            }else {
                noDataLabel.isHidden = true
                collectionView.isHidden = false
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        initCollectionView()
    }
    
    func initCollectionView(){
        collectionView.registerCellNib(cellClass: CharacterItemCell.self)
        collectionView.delegate = self
        collectionView.dataSource  = self
    }
    
}
extension CharctersSectionsCell:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(indexPath: indexPath) as CharacterItemCell
        guard let character = characters?[indexPath.row] else {
            return cell
        }
        cell.section = self.sectionTitleLabel.text
        cell.item = character
        return cell
    }
}
extension CharctersSectionsCell:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 3.4) - 15, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
