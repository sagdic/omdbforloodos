//
//  MovieCollectionViewCell.swift
//  omdbforloodos
//
//  Created by tayfun on 9.10.2022.
//

import UIKit
import SDWebImage

class MovieCollectionViewCell: UICollectionViewCell {
        
        static let identifier = "MovieCollectionViewCell"
    
        private let posterImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            return imageView
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            contentView.addSubview(posterImageView)
        }

        required init?(coder: NSCoder) {
            fatalError()
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            posterImageView.frame = contentView.bounds
        }
        
        public func configure(with model: String) {
            guard let url = URL(string: model) else {return}
            posterImageView.sd_setImage(with: url, completed: nil)
        }
    }
