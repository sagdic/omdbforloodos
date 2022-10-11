//
//  SearchResultViewController.swift
//  omdbforloodos
//
//  Created by tayfun on 8.10.2022.
//

import UIKit
import Firebase

class SearchResultViewController: UIViewController {
    public var movies: [Movie] = [Movie]()

    public let searchResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 2 - 10, height: 300)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(searchResultsCollectionView)
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsCollectionView.frame = view.bounds
    }
}


//MARK: - EXTENSIONS
extension SearchResultViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {return UICollectionViewCell()}
        
        let movie = movies[indexPath.row]
        cell.configure(with: movie.Poster)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let movie = movies[indexPath.row]
        guard let movieTitle = movie.Title else {return}
        
        APICaller.shared.getMovieTrailer(with: movieTitle + " trailer") { result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = MovieDetailViewController()
                    vc.configure(with: MovieDetailViewModel(Title: movieTitle,youtubeView: videoElement ,year: movie.Year))
                    Firebase.Analytics.logEvent("movie_details_log", parameters: ["Title": movieTitle])
                    if let sheet = vc.sheetPresentationController {
                        sheet.prefersGrabberVisible = true
                        sheet.preferredCornerRadius = 24
                    }
                    self.present(vc, animated: true, completion: nil)
                }

            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    CustomToast.show(message: "YoutubeAPI Quota Exceeded", bgColor: .red, textColor: .white, labelFont: .boldSystemFont(ofSize: 24), showIn: .top, controller: self)
                }
                
            }
        
        }
    }
}

