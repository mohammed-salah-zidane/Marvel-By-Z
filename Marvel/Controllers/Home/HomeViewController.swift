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
    
    //MARK:- helper variables
    @IBOutlet weak var tableView: UITableView!
    var pageCount = 0
    private var isPullingUp = false
    private var isLoadingData = false
    let bottomRefreshController = UIRefreshControl()
    let topRefresherController = UIRefreshControl()
    var searchController : UISearchController!
    var searchKeyword = ""
    var isRefreshRequest = false
    let reachability = try! Reachability()
    
    //MARk:- search results data
    var searchResultCharcters = [MarvelCharacter](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    //MARK:- for toggle table view to reuse withing search results
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
    //MARK:- marvel charcters data
    var marvelCharacters:[MarvelCharacter]?{
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK:- LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitleIamge()
        initTableView()
        addRefreshControll()
        fetchCharcters()
        startReachabilityNotifier()
        
    }
    
    //MARK:- Fetch Result Request
    func fetchCharcters(){
        
        if  isLoadingData {
            //MARk :- return if currently loading data
            return
        }
        isLoadingData = true
        
        if !isRefreshRequest {
            self.tableView.showLoadingIndicator()
        }
        Router.shared.fetchCharacters(name:searchKeyword,offset: pageCount) {[unowned self] (success, charctersModel) in
            self.tableView.hideLoadingIndicator()
            if success {
                //increase page count for next page
                self.pageCount  += 10
                //update character list
                self.updateCharacterList(with: (charctersModel?.charcters)!)
            }else{
                //if failed to fetch
                if self.reachability.connection == .unavailable {
                    if self.isUsingTableForSearch {
                        //show notification message on searchBar
                        Commons.showNotificationMessage(message: "Please check your Internet connection or try again.", type: .error,view:self.searchController.searchBar)
                    }else {
                        //show notification message on top of the view
                        Commons.showNotificationMessage(message: "Please check your Internet connection or try again.", type: .error,view:self.view)
                    }
                    //load chached value
                    DispatchQueue.main.async { [unowned self] in
                        self.marvelCharacters = MarvelCharactersChacheManager.getChechedValue()
                    }
                }
                
            }
            //remove loaders and update loading state
            self.isLoadingData = false
            self.topRefresherController.endRefreshing()
            self.tableView.bottomRefreshControl?.endRefreshing()
        }
    }
    
    //MARK:- register reachability for notification and start listen
    func startReachabilityNotifier(){
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    //MARK:- ADD refresh controll for refresh and getMore data
    func addRefreshControll(){
        topRefresherController.tintColor = .white
        topRefresherController.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        topRefresherController.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(topRefresherController)
        bottomRefreshController.tintColor = .white
        bottomRefreshController.triggerVerticalOffset = 50
        tableView.bottomRefreshControl = bottomRefreshController
    }
    //MARK:- Refresh Data
    @objc func refresh(){
        isRefreshRequest = true
        resetValuesForRefresh()
        fetchCharcters()
    }
    //MARK: - Handle response result for fetch and add more data and save marvel charcters to chache
    func updateCharacterList(with characters: [MarvelCharacter]){
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
        //save marvel characters into chache
        MarvelCharactersChacheManager.chacheValue(self.marvelCharacters)
    }
    
    //MARK:- clearing here old data search results with current running tasks
    func resetValuesForRefresh(){
        /* -1- cancel current request */
        Router.shared.cancelCurrentTask()
        /* -2- reset search  */
        self.marvelCharacters = nil
        /* -2- reset page count and loading status */
        pageCount = 0
        isLoadingData = false
    }
    //MARK:- init table view and register cells
    func initTableView(){
        tableView.registerCellNib(cellClass: CharacterCell.self)
        tableView.registerCellNib(cellClass: ResultsCell.self)
    }
    
    //MARK:- Search button handler
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
    
    deinit {
        reachability.stopNotifier()
    }
}
//MARK: - Conform TableView Delegate, Datasource
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
            
            NavigationManager.navigateToCharacterDetails(id: searchResultCharcters[indexPath.row].id, character: searchResultCharcters[indexPath.row], image: cell.resultImageView.image, self, isFromSearch: true)
        }else {
            let cell = tableView.cellForRow(at: indexPath) as! CharacterCell
            
            NavigationManager.navigateToCharacterDetails(id: marvelCharacters?[indexPath.row].id, character: marvelCharacters?[indexPath.row], image: cell.charcterImageView.image, self, isFromSearch: false)
        }
        
    }
}

//MARK: - Scrollview Delegate
extension HomeViewController: UIScrollViewDelegate {
    
    //MARK :- Getting user scroll down event here
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= (scrollView.contentSize.height)){
            //Start locading new data from here
            self.isRefreshRequest = true
            fetchCharcters()
        }
    }
}

//MARK: - Conform Search Delegates
extension HomeViewController:UISearchControllerDelegate,UISearchBarDelegate,UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchResultCharcters.removeAll()
        if let text = searchBar.text {
            searchKeyword = text
            search()
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchTE",searchText)
        searchKeyword = searchText
        search()
    }
    func search(){
        Router.shared.cancelCurrentTask()
        isLoadingData = false
        pageCount = 0
        fetchCharcters()
    }
    func didDismissSearchController(_ searchController: UISearchController) {
        isUsingTableForSearch = false
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
