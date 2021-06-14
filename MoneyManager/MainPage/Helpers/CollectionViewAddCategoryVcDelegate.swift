//
//  CollectionViewExtension.swift
//  CoreDataTest
//
//  Created by RM on 08.06.2021.
//

import Foundation

extension CollectionView: AddCategoryVcDelegate {
    
    func addIncomeCategory(_ categoryName: String?, image: String) {
        let category = Category(context: self.context)
        category.sections = sections![0]
        category.categoryTitle = categoryName
        category.categoryID = UUID()
        category.imageName = image
        
        do {
            try context.save()
        }
        catch {
            print("error")
        }
        self.fetchData()
    }
    
    func addCostsCategory(_ categoryName: String?, image: String) {
        let category = Category(context: self.context)
        category.sections = sections![1]
        category.categoryTitle = categoryName
        category.categoryID = UUID()
        category.imageName = image
       
        do {
            try context.save()
        }
        catch {
            print("error")
        }
        self.fetchData()
    }
    
    

}
