//
//  ViewController.swift
//  Marvel
//
//  Created by prog_zidane on 12/1/19.
//  Copyright © 2019 prog_zidane. All rights reserved.
//

import UIKit
import CCBottomRefreshControl
class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var pageCount = 0
    private var isPullingUp = false
    private var isLoadingData = false
    let bottomRefreshController = UIRefreshControl()
    let topRefresherController = UIRefreshControl()
    var searchController : UISearchController!
    var searchKeyword = ""
    var searchResultCharcters = [MarvelCharacter](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var isUsingTableForSearch = false {
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            if !self.isUsingTableForSearch {
                self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
        }
    }
    var marvelCharacters:[MarvelCharacter]?{
        didSet{
            DispatchQueue.main.async {
               self.tableView.reloadData()
            }
        }
    }
    var isNoFurtherData:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitleIamge()
        initTableView()
        addRefreshControll()
        fetchCharcters()
    }

    func fetchCharcters(){
        print(searchKeyword)
        if  isLoadingData {
            return
        }
        isLoadingData = true
        Router.shared.fetchCharacters(name:searchKeyword,offset: pageCount) {[unowned self] (success, charctersModel) in
            if success {
                self.pageCount  += 10
                self.updateCharacterList(with: (charctersModel?.charcters)!)
            }
            self.isLoadingData = false
            self.topRefresherController.endRefreshing()
            self.tableView.bottomRefreshControl?.endRefreshing()
        }
    }
    func addRefreshControll(){
        topRefresherController.tintColor = .white
        topRefresherController.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        topRefresherController.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(topRefresherController)
        bottomRefreshController.tintColor = .white
        bottomRefreshController.triggerVerticalOffset = 50
        tableView.bottomRefreshControl = bottomRefreshController
        //self.tableView.refreshFooter = self.footer
    }
    @objc func refresh(){
        resetValuesForRefresh()
        fetchCharcters()
    }
    //MARK: - Handle response result
    func updateCharacterList(with characters: [MarvelCharacter]){
       // let uniqueCharcter = characters.unique()
        if isUsingTableForSearch {
            if self.searchResultCharcters.count  == 0 {
                self.searchResultCharcters = characters
            }else{
                self.searchResultCharcters.append(contentsOf: characters)
            }
        }else {
            if self.marvelCharacters == nil {
                self.marvelCharacters = characters
            }else{
                self.marvelCharacters?.append(contentsOf: characters)
            }
        }
        //self.marvelCharacters = self.marvelCharacters!.unique()
    }
    
    //MARK:- clearing here old data search results with current running tasks
    func resetValuesForRefresh(){
        /* -1- cancel current request */
        Router.shared.cancelCurrentTask()
        /* -2- reset search photos  */
        self.marvelCharacters = nil
       /// self.localPhotos.removeAll()
        /* -2- reset page count */
        pageCount = 0
        isLoadingData = false
        isNoFurtherData = false
    }
    func initTableView(){
        tableView.registerCellNib(cellClass: CharacterCell.self)
        tableView.registerCellNib(cellClass: ResultsCell.self)
    }

    @IBAction func openSearchBarHandler(_ sender: Any) {
        // Create the search controller and specify that it should present its results in this same view
        searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.loadViewIfNeeded()
        tableView.isScrollEnabled = true
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.barTintColor = navigationController?.navigationBar.barTintColor
        searchController.searchBar.tintColor = .red
        searchController.hidesNavigationBarDuringPresentation = true
        searchKeyword = ""
        self.tableView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
        isUsingTableForSearch = true
        present(searchController, animated: true, completion: nil)
    }
}
extension HomeViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isUsingTableForSearch ? searchResultCharcters.count  : marvelCharacters?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isUsingTableForSearch {
            let cell = tableView.dequeue() as ResultsCell
            cell.marvelCharacter = self.searchResultCharcters[indexPath.row]
            return cell
        }
        let cell = tableView.dequeue() as CharacterCell
        guard let character = marvelCharacters?[indexPath.row] else {
            return cell
        }
        cell.marvelCharacter = character
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isUsingTableForSearch{
            let cell = tableView.cellForRow(at: indexPath) as! ResultsCell
             NavigationManager.navigateToCharacterDetails(id: searchResultCharcters[indexPath.row].id, character: searchResultCharcters[indexPath.row], image: cell.resultImageView.image, self)
        }else {
            let cell = tableView.cellForRow(at: indexPath) as! CharacterCell
          
             NavigationManager.navigateToCharacterDetails(id: marvelCharacters?[indexPath.row].id, character: marvelCharacters?[indexPath.row], image: cell.charcterImageView.image, self)
        }
        
    }
}

//MARK: - Scrollview Delegate
extension HomeViewController: UIScrollViewDelegate {

    //MARK :- Getting user scroll down event here
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= (scrollView.contentSize.height)){
            //Start locading new data from here
           // if !isUsingTableForSearch{
                fetchCharcters()
            
        }
    }
}
extension HomeViewController:UISearchControllerDelegate,UISearchBarDelegate,UISearchResultsUpdating{

    func updateSearchResults(for searchController: UISearchController) {
     
    
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchResultCharcters.removeAll()
        if let text = searchBar.text {
            searchKeyword = text
            Router.shared.cancelCurrentTask()
            isLoadingData = false
            pageCount = 0
            fetchCharcters()
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let text = searchBar.text {
            searchKeyword = text
            Router.shared.cancelCurrentTask()
            pageCount = 0
            isLoadingData = false
            fetchCharcters()
        }
    }
    func didDismissSearchController(_ searchController: UISearchController) {
        isUsingTableForSearch = false
        //resetValuesForRefresh()
        pageCount = 0
    }
    func didPresentSearchController(_ searchController: UISearchController) {
        self.tableView.isScrollEnabled = true
    }
    func willPresentSearchController(_: UISearchController) {
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
        navigationController?.hidesBarsOnSwipe = true

    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = true
        }
        navigationController?.hidesBarsOnSwipe = false
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isUsingTableForSearch = false
        searchKeyword = ""
        Router.shared.cancelCurrentTask()
        searchResultCharcters.removeAll()
        tableView.reloadData()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchKeyword = ""
        searchResultCharcters.removeAll()
        tableView.reloadData()
        return true
    }
}
