//
//  Transaction+CoreDataProperties.swift
//  
//
//  Created by RM on 18.05.2021.
//
//

import Foundation
import CoreData

extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var amount: NSDecimalNumber?
    @NSManaged public var date: Date?
    @NSManaged public var imageName: String?
    @NSManaged public var category: Category?

}
