//
//  URLsCell.swift
//  Marvel
//
//  Created by prog_zidane on 12/4/19.
//  Copyright © 2019 prog_zidane. All rights reserved.
//

import UIKit

class URLsCell: UITableViewCell {

    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    var urls :[Urls]?{
        didSet{
            //update table height
            tableHeight.constant = CGFloat((40 * (self.urls!.count))  + (5 * (self.urls!.count)))
            self.tableView.reloadData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        initTableView()
    }
    
    //MARK:- init tableView and register cell
    func initTableView(){
        tableView.registerCellNib(cellClass: LinkCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
}
//MARK: - Conform TableView Delegate, Datasource
extension URLsCell:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urls?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as LinkCell
        guard let link = urls?[indexPath.row] else {
            return cell
        }
        cell.linkName.text = link.type
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let link = urls?[indexPath.row] else {
            return
        }
        if let url = URL(string: link.url!) {
            UIApplication.shared.open(url)
        }
    }
}
