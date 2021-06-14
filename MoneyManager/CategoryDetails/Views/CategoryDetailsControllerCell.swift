//
//  ListViewControllerCell.swift
//  CoreDataTest
//
//  Created by RM on 02.06.2021.
//

import UIKit
import EasyPeasy

class CategoryDetailsControllerCell: UITableViewCell {
    
    static let reuseId: String = "listCellIdentifier"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layer.cornerRadius = frame.height/2
        contentView.addSubview(amountLable)
        contentView.addSubview(time)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        amountLable.easy.layout([Left(20), CenterY()])
    }
    
    var categoryImage = UIImageView()
    
    var time: UILabel = {
        let lable = UILabel()
        lable.text = ""
        lable.textColor = .black
        return lable
        
    }()
    
    var amountLable: UILabel = {
        let amountLbl = UILabel()
        amountLbl.font = .boldSystemFont(ofSize: 18)
        amountLbl.textColor = .black
        return amountLbl
    }()
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
