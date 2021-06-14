//
//  CollectionViewCell.swift
//  CoreDataTest
//
//  Created by RM on 17.05.2021.
//

import UIKit
import EasyPeasy

class CollectionViewCell: UICollectionViewCell {

    static let reuseId: String = "mainScreenCellIndetifier"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(title)
        contentView.addSubview(amountLable)
        contentView.addSubview(imageView)
        layer.cornerRadius = frame.height/2
        title.easy.layout([CenterX(), CenterY(-45), Width(90), Height(40)])
        amountLable.easy.layout([CenterX(), CenterY(45), Width(85), Height(30)])
        imageView.easy.layout([CenterX(), CenterY(0), Width(30), Height(30)])

        title.numberOfLines = 2
        title.lineBreakMode = .byCharWrapping
        
        title.textAlignment = .center
        amountLable.textAlignment = .center
        
    }
    
    var title: UILabel = {
        let lable = UILabel()
        lable.font = .boldSystemFont(ofSize: 15)
        lable.textColor = .black
        return lable
        
    }()
    
    var amountLable: UILabel = {
        let amountLbl = UILabel()
        amountLbl.font = .boldSystemFont(ofSize: 15)
        amountLbl.textColor = .black
        return amountLbl
    }()
    
    var imageView = UIImageView()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}

