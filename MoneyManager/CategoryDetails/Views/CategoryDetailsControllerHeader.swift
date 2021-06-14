//
//  ListSectionHeader.swift
//  CoreDataTest
//
//  Created by RM on 02.06.2021.
//

import UIKit
import EasyPeasy

class CategoryDetailsControllerHeader: UITableViewHeaderFooterView {
    
    static let reuseid = "tableHeader"
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(view)
        contentView.addSubview(dateLable)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        view.easy.layout([Left(), CenterY(), CenterX(), Height(35)])
        dateLable.easy.layout([CenterX(), CenterY()])
        
    }
    var view: UIView = {
        let lable = UIView()

        return lable
        
    }()
    
    var dateLable: UILabel = {
        let dateLbl = UILabel()
        dateLbl.font = .boldSystemFont(ofSize: 18)
        dateLbl.textColor = .black
        return dateLbl
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
