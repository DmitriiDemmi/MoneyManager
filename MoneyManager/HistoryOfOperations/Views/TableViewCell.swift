//
//  TableViewCell.swift
//  CoreDataTest
//
//  Created by RM on 01.06.2021.
//

import UIKit
import EasyPeasy

class HistoryTableViewCell: UITableViewCell {
    
    static let reuseId: String = "historyCellIdentofier"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layer.cornerRadius = frame.height/2
        contentView.addSubview(amountLable)
        contentView.addSubview(categoryImage)
        contentView.addSubview(title)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        title.easy.layout([Left(65), CenterY(-10)])
        amountLable.easy.layout([Right(50), CenterY(-10)])
        categoryImage.easy.layout([CenterX(-170), Top(20), Width(30), Height(30)])
    }
    
    var categoryImage = UIImageView()

    var title: UILabel = {
        let lable = UILabel()
        lable.font = .boldSystemFont(ofSize: 15)
        lable.textColor = .black
        return lable
        
    }()
    
    var amountLable: UILabel = {
        let amountLbl = UILabel()
        amountLbl.font = .boldSystemFont(ofSize: 16)
        amountLbl.textColor = .black
        return amountLbl
    }()
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
