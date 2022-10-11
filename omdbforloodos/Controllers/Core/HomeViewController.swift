//
//  HomeViewController.swift
//  omdbforloodos
//
//  Created by tayfun on 8.10.2022.
//

import UIKit
import FirebaseRemoteConfig

class HomeViewController: UIViewController {
    
    private var loadingView = LoadingView()
    private var movies: [Movie] = [Movie]()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultViewController())
        controller.searchBar.placeholder = "Enter min. 3 characters to search"
        controller.searchBar.searchBarStyle = .minimal
        controller.searchBar.searchTextField.leftView?.tintColor = UIColor(named: "loodosColor")
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        view.backgroundColor = .systemBackground
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = UIColor(named: "loodosColor")
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
    }
}


//MARK: - EXTENSIONS
extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
                query.trimmingCharacters(in: .whitespaces).count >= 3,
              
                let resultsController = searchController.searchResultsController as? SearchResultViewController else {return}
        
        loadingView.showLoadingView(on: resultsController)
        APICaller.shared.searchMovies(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    self.loadingView.dismissLoadingView()
                    resultsController.movies = movies
                    resultsController.searchResultsCollectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                    resultsController.movies.removeAll()
                    resultsController.searchResultsCollectionView.reloadData()
                        CustomToast.show(message: "No results.", bgColor: .red, textColor: .white, labelFont: .boldSystemFont(ofSize: 24), showIn: .top, controller: resultsController)
                    self.loadingView.dismissLoadingView()
                    
                }
            }
        }
        if query.isEmpty {
            resultsController.movies.removeAll()
            resultsController.searchResultsCollectionView.reloadData()
        }
    }
}
