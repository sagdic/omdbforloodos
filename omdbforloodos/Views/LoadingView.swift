//
//  LoadingView.swift
//  omdbforloodos
//
//  Created by tayfun on 9.10.2022.
//

//for displaying gif
import Gifu

class LoadingView {
    
// The reason is why the gif displays poor quality: 300x200 low resolution gif
    private let loadingView: GIFImageView = {
        let imageView = GIFImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.animate(withGIFNamed: "loodos")
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
        return imageView
    }()

    func showLoadingView(on viewController: UIViewController) {
        guard let targetView = viewController.view else {return}
        loadingView.frame = targetView.bounds
        targetView.addSubview(loadingView)
        loadingView.startAnimatingGIF()
        loadingView.centerXAnchor.constraint(equalTo: targetView.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: targetView.centerYAnchor).isActive = true
        loadingView.isHidden = false
    }

    func dismissLoadingView() {
        loadingView.stopAnimatingGIF()
        loadingView.isHidden = true
    }
}
