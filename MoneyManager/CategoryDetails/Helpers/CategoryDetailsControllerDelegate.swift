//
//  CategoryDetailsController.swift
//  CoreDataTest
//
//  Created by RM on 08.06.2021.
//

import Foundation

extension CategoryDetailsController: AddAmountVcDelegate {
    
    func getAmount(_ newAmount: Decimal, date: Date) {
        let newTransaction = Transaction(context: self.context)
        newTransaction.category = category
        newTransaction.amount = NSDecimalNumber(decimal: newAmount)
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let componentsDate = Calendar.current.date(from: components)!
        newTransaction.date = componentsDate
        newTransaction.imageName = category!.imageName
        do {
            try self.context.save()
        }
        catch {
            print("error")
        }
        fetchTransaction()
    }
}
