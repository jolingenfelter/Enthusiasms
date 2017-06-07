//
//  ContentCollectionViewCell.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 11/14/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

class ContentCollectionViewCell: UICollectionViewCell {
    
    lazy var titleLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        self.contentView.addSubview(label)
        
        return label
        
    }()
    
    lazy var thumbnail: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        self.contentView.addSubview(imageView)
        
        return imageView
        
    }()
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        // TitleLabel Constraints
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            titleLabel.widthAnchor.constraint(equalToConstant: 200),
            titleLabel.heightAnchor.constraint(equalToConstant: 50)
            ])
        
        // ThumbnailConstraints
        thumbnail.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            thumbnail.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            thumbnail.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -10),
            thumbnail.widthAnchor.constraint(equalToConstant: 200),
            thumbnail.heightAnchor.constraint(equalToConstant: 200)
            ])
        
    }
    
}
