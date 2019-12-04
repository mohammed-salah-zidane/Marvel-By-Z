//
//  CharacterDetialsViewController.swift
//  Marvel
//
//  Created by prog_zidane on 12/2/19.
//  Copyright © 2019 prog_zidane. All rights reserved.
//

import UIKit
import LetheStretchyHeader


let offset_HeaderStop:CGFloat = 45.0 // At this offset the Header stops its transformations
let offset_B_LabelHeader:CGFloat = 100.0 // At this offset the Black label reaches the Header
let distance_W_LabelHeader:CGFloat = 25.0 // The distance between the bottom of the Header and the top of the White Label


class CharacterDetialsViewController: UIViewController {
    
    @IBOutlet weak var backButtonTop: NSLayoutConstraint!
    @IBOutlet weak var titleHeaderTop: NSLayoutConstraint!
    @IBOutlet weak var alterNavHeight: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var descriptoiLabel: UILabel!
    @IBOutlet weak var charcterNameLabel: UILabel!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    @IBOutlet weak var alterHeaderImageView:UIImageView!
    @IBOutlet weak var headerBlurImageView:UIImageView!
    
    
    @IBOutlet weak var tableView:UITableView!
    private var lastContentOffset: CGFloat = 0
    
    @IBOutlet weak var alterNavigationView: UIView!
    @IBOutlet weak var titleHeaderLabel: UILabel!
    
    
    var characterImage:UIImage?
    var id:Int?
    var character:MarvelCharacter?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCellNib(cellClass: CharctersSectionsCell.self)
        tableView.registerCellNib(cellClass: URLsCell.self)
        //tableView.tableHeaderView = headerView
        updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    func updateUI(){
        self.navigationItem.title = self.character?.name
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        
        headerImageView.image = self.characterImage
        backgroundImageView.image = self.characterImage
        
        if self.character != nil {
            if characterImage == nil{
                headerImageView.nuke(url: self.character?.thumbnail!.url, {_ in })
                backgroundImageView.nuke(url:  self.character?.thumbnail!.url,{_ in})
            }
            self.descriptoiLabel.text = self.character?.description ?? ""
            self.charcterNameLabel.text = self.character?.name ?? ""
        }
        setupAlterHeaderView()
        
        
    }
    
    func setupAlterHeaderView(){
        
        titleHeaderLabel.text = self.character?.name ?? ""
        
        // Header - Image
        alterHeaderImageView?.image = self.characterImage
        alterHeaderImageView?.contentMode = .scaleAspectFill
        
        // Header - Blurred Image
        
        self.headerImageView.image = self.characterImage
        self.headerBlurImageView.addBlur(1)
        headerBlurImageView?.contentMode = .scaleAspectFill
        alterHeaderImageView.alpha = 0
        headerBlurImageView?.alpha = 0.0
        alterNavigationView.alpha = 0
        alterNavigationView.clipsToBounds = true
        
        
//        if Device.IS_IPHONE_X {
//            alterNavHeight.constant = 120
//            backButtonTop.constant = 43
//            titleHeaderTop.constant = 117
//
//        }
    }
    
    @IBAction func backButtonHandler(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
extension CharacterDetialsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row != 4{
            let cell = tableView.dequeue() as CharctersSectionsCell
            switch indexPath.row {
            case 0:
                cell.sectionTitleLabel.text = "COMICS"
                cell.characters = character?.comics?.items
                cell.noDataText = "There is no available Comics"
            case 1:
                cell.sectionTitleLabel.text = "SERIES"
                cell.characters = character?.series?.items
                cell.noDataText = "There is no available Series"
                
            case 2:
                cell.sectionTitleLabel.text = "STORIES"
                cell.characters = character?.stories?.items
                cell.noDataText = "There is no available Stories"
                
            case 3:
                cell.sectionTitleLabel.text = "EVENTS"
                cell.characters = character?.events?.items
                cell.noDataText = "There is no available Events"
            default:
                break
            }
            cell.layer.shouldRasterize = true
            cell.layer.rasterizationScale = UIScreen.main.scale
            return cell
        }
        let cell = tableView.dequeue() as URLsCell
        cell.urls = character?.urls
        return cell
    }
    
    
}
extension CharacterDetialsViewController: UIScrollViewDelegate {
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        var headerTransform = CATransform3DIdentity
        
        // PULL DOWN -----------------
        
        if offset < 0 {
            
            let headerScaleFactor:CGFloat = -(offset) / alterNavigationView.bounds.height
            let headerSizevariation = ((alterNavigationView.bounds.height * (1.0 + headerScaleFactor)) - alterNavigationView.bounds.height)/2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            
            alterNavigationView.layer.transform = headerTransform
        } // SCROLL UP/DOWN ------------
            
        else {
            
            // Header -----------
            
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offset_HeaderStop, -offset), 0)
            
            //  ------------ Label
            
            let labelTransform = CATransform3DMakeTranslation(0, max(-distance_W_LabelHeader, offset_B_LabelHeader - offset), 0)
            titleHeaderLabel.layer.transform = labelTransform
            
            //  ------------ Blur
            
            headerBlurImageView?.alpha = min (1.0, (offset - offset_B_LabelHeader)/distance_W_LabelHeader)
            alterHeaderImageView?.alpha = min (1.0, (offset - offset_B_LabelHeader)/distance_W_LabelHeader)
            alterNavigationView?.alpha = min (1.0, (offset - offset_B_LabelHeader)/distance_W_LabelHeader)
            
            if offset <= offset_HeaderStop {
                
                if headerImageView.layer.zPosition < alterNavigationView.layer.zPosition{
                    alterNavigationView.layer.zPosition = 0
                    alterNavHeight.constant = 107
                    backButtonTop.constant = 30
                    titleHeaderTop.constant = 104
                    
                }
                
            }else {
                if headerImageView.layer.zPosition >= alterNavigationView.layer.zPosition{
                    alterNavigationView.layer.zPosition = 2
                    backButton.layer.zPosition = 3
                    alterNavHeight.constant = 120
                    backButtonTop.constant = 43
                    titleHeaderTop.constant = 117
                    
                }
            }
        }
        
        // Apply Transformations
        alterNavigationView.layer.transform = headerTransform
    }
    
}
