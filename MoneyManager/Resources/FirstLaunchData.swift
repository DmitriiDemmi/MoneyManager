//
//  Helper.swift
//  CoreDataTest
//
//  Created by RM on 19.05.2021.
//

import UIKit
import EasyPeasy
import CoreData

func setupData() {
    
    let delegate = UIApplication.shared.delegate as? AppDelegate
    
    if let context = delegate?.persistentContainer.viewContext {
//        let fetchRequest: NSFetchRequest<Section> = Section.fetchRequest()
        let incomeSection = NSEntityDescription.insertNewObject(forEntityName: "Section", into: context) as! Section
        incomeSection.title = "Доходы"
        incomeSection.sectionID = UUID()
        
        let costsSection = NSEntityDescription.insertNewObject(forEntityName: "Section", into: context) as! Section
        costsSection.title = "Расходы"
        costsSection.sectionID = UUID()
        
        let category = NSEntityDescription.insertNewObject(forEntityName: "Category", into: context) as! Category
        category.sections = incomeSection
        category.categoryTitle = "Зарплата"
        category.categoryID = UUID()
        category.imageName = "9"
        
        let category2 = NSEntityDescription.insertNewObject(forEntityName: "Category", into: context) as! Category
        category2.sections = incomeSection
        category2.categoryTitle = "Дивиденды"
        category2.categoryID = UUID()
        category2.imageName = "6"
        
        let category3 = NSEntityDescription.insertNewObject(forEntityName: "Category", into: context) as! Category
        category3.sections = costsSection
        category3.categoryTitle = "Фитнес"
        category3.categoryID = UUID()
        category3.imageName = "27"
        
        let category4 = NSEntityDescription.insertNewObject(forEntityName: "Category", into: context) as! Category
        category4.sections = costsSection
        category4.categoryTitle = "Продукты"
        category4.categoryID = UUID()
        category4.imageName = "7"
        
        let category5 = NSEntityDescription.insertNewObject(forEntityName: "Category", into: context) as! Category
        category5.sections = costsSection
        category5.categoryTitle = "Кафе"
        category5.categoryID = UUID()
        category5.imageName = "24"
        
        let category6 = NSEntityDescription.insertNewObject(forEntityName: "Category", into: context) as! Category
        category6.sections = costsSection
        category6.categoryTitle = "Досуг"
        category6.categoryID = UUID()
        category6.imageName = "4"
        
        let category7 = NSEntityDescription.insertNewObject(forEntityName: "Category", into: context) as! Category
        category7.sections = costsSection
        category7.categoryTitle = "Транспорт"
        category7.categoryID = UUID()
        category7.imageName = "21"
        
        let category8 = NSEntityDescription.insertNewObject(forEntityName: "Category", into: context) as! Category
        category8.sections = costsSection
        category8.categoryTitle = "Красота"
        category8.categoryID = UUID()
        category8.imageName = "17"
        
        do {
            try context.save()
        } catch {
            print("error")
        }
    }
    
    let context = CoreDataService.shared.persistentContainer(for: .loans).viewContext
    let myLoans = NSEntityDescription.insertNewObject(forEntityName: "LoansCategory", into: context) as! LoansCategory
    myLoans.categoryID = LoanCategories.loans.rawValue
    myLoans.title = "Я взял"
    
    let myCredits = NSEntityDescription.insertNewObject(forEntityName: "LoansCategory", into: context) as! LoansCategory
    myCredits.categoryID = LoanCategories.credits.rawValue
    myCredits.title = "Я дал"
    
    let person = NSEntityDescription.insertNewObject(forEntityName: "LoansPerson", into: context) as! LoansPerson
    person.amount = 1000
    
    let person2 = NSEntityDescription.insertNewObject(forEntityName: "LoansPerson", into: context) as! LoansPerson
    person2.personID = UUID()
    person2.category = myLoans
    person2.name = "Наталья"
    person2.amount = 20
    
    let person3 = NSEntityDescription.insertNewObject(forEntityName: "LoansPerson", into: context) as! LoansPerson
    person3.personID = UUID()
    person3.category = myCredits
    person3.name = "Игорь"
    person3.amount = 500
    
    do {
        try context.save()
    } catch {
        print("error")
    }
    
}
