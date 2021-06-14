//
//  CustomSectionHeader.swift
//  CoreDataTest
//
//  Created by RM on 01.06.2021.
//

import UIKit
import EasyPeasy

class HistoryOfOperationsSectionHeader: UITableViewHeaderFooterView {
    static let reuseid = "TableHeader"
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(view)
        contentView.addSubview(dateLable)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        view.easy.layout([Left(), CenterY(), CenterX(), Height(30)])
        dateLable.easy.layout([CenterX(), CenterY()])
        
    }
    var view: UIView = {
        let lable = UIView()
        return lable
        
    }()
    
    var dateLable: UILabel = {
        let dateLbl = UILabel()
        dateLbl.font = .boldSystemFont(ofSize: 16)
        dateLbl.textColor = .black
        return dateLbl
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
