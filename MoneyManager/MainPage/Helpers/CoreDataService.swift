//
//  CoreDataService.swift
//  MoneyManager
//
//  Created by Aleksey Nikolaenko on 16.09.2022.
//

import Foundation
import CoreData

enum DataType {
    case loans
    
    var dataBaseName: String {
        switch self {
        case .loans: return "LoansDataBase"
        }
    }
}

final class CoreDataService {
    
    static let shared = CoreDataService()
    
    private lazy var containers = [DataType : NSPersistentContainer]()
    
    func persistentContainer(for dataType: DataType) -> NSPersistentContainer {
        if let container = containers[dataType] {
            return container
        }
        let container = NSPersistentContainer(name: dataType.dataBaseName)
        container.loadPersistentStores { _, error in
            //FIXME: Add error hendling
            if let error = error as NSError? {
                fatalError("Unresolved error: \(error), \(error.userInfo)")
            }
        }
        containers[dataType] = container
        return container
    }
    
    func saveContext(for dataType: DataType) {
        if let context = containers[dataType]?.viewContext {
            do {
                try context.save()
            } catch {
                //FIXME: Add error hendling
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
}
