//
//  AddAmountProtocol.swift
//  CoreDataTest
//
//  Created by RM on 08.06.2021.
//

import Foundation

protocol AddAmountVcDelegate {
    func getAmount(_ newAmount: Decimal, date: Date)
}
