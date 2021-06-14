//
//  Category+CoreDataProperties.swift
//  
//
//  Created by RM on 18.05.2021.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var categoryID: UUID?
    @NSManaged public var categoryTitle: String?
    @NSManaged public var imageName: String
    @NSManaged public var sections: Section?
    @NSManaged public var transactions: [Transaction]?

}

// MARK: Generated accessors for transactions
extension Category {

    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: Transaction)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: Transaction)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSSet)

}
