//
//  CollectionViewExtensions.swift
//  Marvel
//
//  Created by prog_zidane on 12/1/19.
//  Copyright © 2019 prog_zidane. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    func scrollToNextItem() {
        scrollToItem(at: IndexPath(row: visibleCurrentCellIndexPath! + 1, section: 0), at: .right, animated: true)
    }
    
    func scrollToPreviousItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x - self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset)
    }
    
    func moveToFrame(contentOffset : CGFloat) {
        self.setContentOffset(CGPoint(x: contentOffset, y: self.contentOffset.y), animated: true)
    }
    
    var visibleCurrentCellIndexPath: Int? {
        for cell in visibleCells {
            let indexPath = self.indexPath(for: cell)
            return indexPath?.row
        }
        
        return nil
    }
}
extension UICollectionView {
    
    func registerCellNib<Cell: UICollectionViewCell>(cellClass: Cell.Type){
        self.register(UINib(nibName: String(describing: Cell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: Cell.self))
    }
    
    
    func dequeue<Cell: UICollectionViewCell>(indexPath: IndexPath) -> Cell{
        let identifier = String(describing: Cell.self)
        
        
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? Cell else {
            fatalError("Error in cell")
        }
        
        return cell
    }
    
}
