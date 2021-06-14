//
//  CollectionViewSectionHeader.swift
//  CoreDataTest
//
//  Created by RM on 01.06.2021.
//

import UIKit

class CollectionViewSectionHeader: UICollectionReusableView {
    
    static let identifier = "SectionTitle"
    
     var costsTitle: UILabel = {
        let costs = UILabel()
        costs.font = .boldSystemFont(ofSize: 18)
        costs.textAlignment = .center
        costs.textColor = .black
        return costs
    }()
    
    public func configureCostsTitle() {
        addSubview(costsTitle)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        costsTitle.frame = bounds
    }
}
