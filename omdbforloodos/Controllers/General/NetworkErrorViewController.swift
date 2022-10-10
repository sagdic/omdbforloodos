//
//  NetworkErrorViewController.swift
//  omdbforloodos
//
//  Created by tayfun on 9.10.2022.
//

import UIKit

class NetworkErrorViewController: UIViewController {

    
    private let errorImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "disconnected")
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(errorImageView)
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        errorImageView.frame = self.view.frame
    }

   

}
