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
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        thumbnail = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        
        super.init(frame: frame)
        
        self.contentView.addSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textAlignment = .center
        self.contentView.addSubview(thumbnail)
        thumbnail.contentMode = .scaleAspectFit
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
