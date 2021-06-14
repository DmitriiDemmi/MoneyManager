//
//  CollectionViewDataSource.swift
//  CoreDataTest
//
//  Created by RM on 08.06.2021.
//

import UIKit

extension CollectionView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections!.count
    }
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections![section].categories!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseId, for: indexPath) as! CollectionViewCell
        
        customCell.backgroundColor = UIColor(red: 0.49, green: 0.21, blue: 0.84, alpha: 1)
        customCell.imageView.image = customCell.imageView.image?.withRenderingMode(.alwaysTemplate)
        customCell.imageView.tintColor = UIColor.white
    
        customCell.title.text = "\(sections![indexPath.section].categories![indexPath.row].categoryTitle!)"

        let transactions = sections![indexPath.section].categories![indexPath.row].transactions!
        let mapArray = transactions.map { $0.amount!.intValue }

        if mapArray.isEmpty {
            customCell.amountLable.text = ""
        } else {
            customCell.amountLable.text = "\(mapArray.reduce(0, +))"
        }
        
        customCell.amountLable.textColor = UIColor(red: 0.49, green: 0.21, blue: 0.84, alpha: 1)
        customCell.imageView.image = UIImage(named: sections![indexPath.section].categories![indexPath.row].imageName)
    
        return customCell
    }
    
}
