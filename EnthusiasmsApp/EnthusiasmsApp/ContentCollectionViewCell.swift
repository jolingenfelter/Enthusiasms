//
//  ContentCollectionViewCell.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 11/14/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

class ContentCollectionViewCell: UICollectionViewCell {
    
    var titleLabel: UILabel
    var thumbnail: UIImageView
    
    override init(frame: CGRect) {
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        thumbnail = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        super.init(frame: frame)
        
        self.contentView.addSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        
        self.contentView.addSubview(thumbnail)
        thumbnail.contentMode = .scaleAspectFit
        
        // TitleLabel Constraints
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabelHorizontalConstraint = titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let titleLabelVerticalConstraint = titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        let titleLabelWidthConstraint = titleLabel.widthAnchor.constraint(equalToConstant: 200)
        let titleLabelHeightConstraint = titleLabel.heightAnchor.constraint(equalToConstant: 50)
        
        NSLayoutConstraint.activate([titleLabelHorizontalConstraint, titleLabelVerticalConstraint, titleLabelWidthConstraint, titleLabelHeightConstraint])
        
        // ThumbnailConstraints
        thumbnail.translatesAutoresizingMaskIntoConstraints = false
        
        let thumbnailHorizontalConstraint = thumbnail.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let thumbnailVerticalConstraint = thumbnail.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -10)
        let thumbnailWidthConstraint = thumbnail.widthAnchor.constraint(equalToConstant: 200)
        let thumbnailHeightConstraint = thumbnail.heightAnchor.constraint(equalToConstant: 200)
        
        NSLayoutConstraint.activate([thumbnailHorizontalConstraint, thumbnailVerticalConstraint, thumbnailWidthConstraint, thumbnailHeightConstraint])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
