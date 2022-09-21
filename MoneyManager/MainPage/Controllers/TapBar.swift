//
//  TapBar.swift
//  CoreDataTest
//
//  Created by RM on 14.05.2021.
//

import UIKit
import SwiftUI

class TabBarController: UITabBarController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainPageVC = UINavigationController(rootViewController: CollectionView())
        let hisctoryOfOperation = UINavigationController(rootViewController: HistoryOfOperationsController())
        let loansViewController = UIHostingController(rootView: LoansView().environment(\.managedObjectContext, CoreDataService.shared.persistentContainer(for: .loans).viewContext))
        
        mainPageVC.title = "Категории"
        mainPageVC.tabBarItem.image = UIImage(systemName: "house")
         
        hisctoryOfOperation.title = "История"
        hisctoryOfOperation.tabBarItem.image = UIImage(systemName: "list.bullet")
        
        loansViewController.title = "Долги"
        loansViewController.view.backgroundColor = .white
        
        viewControllers = [mainPageVC, hisctoryOfOperation, loansViewController]
        
        let fontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)]
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)

        tabBar.barTintColor = .white
        tabBar.isTranslucent = false
    }
    
    
}
