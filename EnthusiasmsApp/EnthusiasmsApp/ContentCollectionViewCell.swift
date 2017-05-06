//
//  ContentCollectionViewCell.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 11/14/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

class ContentCollectionViewCell: UICollectionViewCell {
    
    let titleLabel = UILabel()
    let thumbnail = UIImageView()
    
    override func layoutSubviews() {
        
        self.contentView.addSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        
        self.contentView.addSubview(thumbnail)
        thumbnail.contentMode = .scaleAspectFit
        
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
