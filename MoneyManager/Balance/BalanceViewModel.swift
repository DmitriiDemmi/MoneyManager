import Foundation
import SwiftUI
import SwiftDate

class BalanceViewModel: ObservableObject {
    
    enum EditDateMode {
        case begin
        case end
        case cancel
    }
    
    @Published var date: Date = Date()
    
    private var lastSavedDate: Date?
    
    var editDateMode: EditDateMode = .end {
        didSet {
            switch editDateMode {
            case .begin:
                lastSavedDate = date
            case .end:
                lastSavedDate = nil
            case .cancel:
                date = lastSavedDate ?? date
                lastSavedDate = nil
            }
        }
    }
    
    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        return formatter
    }
    
}
 
extension BalanceViewModel {
    
    func moveToPrevMonth() {
        date = date.dateAt(.prevMonth)
    }
    
    func moveToNextMonth() {
        date = date.dateAt(.nextMonth)
    }
    
    var isFutureDate: Bool {
        date.dateAt(.startOfMonth) >= Date().dateAt(.startOfMonth)
    }
    
    var currentMonthName: String {
        date.monthName(.default)
    }
    
}

extension BalanceViewModel {
    
    typealias Balance = (whole: String, remainder: String?, raw: Decimal)
    typealias Result = (balance: Balance, percent: Double, isGoodIncome: Bool)

    func calc(transatcions: FetchedResults<Transaction>) -> Result {
        let transatcions = transatcions.filter({ $0.date!.month == date.month })
        let percent = incomePercent(transatcions: transatcions)
        return (balance(transatcions: transatcions), percent, percent >= 0.5)
    }
    
    private func balance(transatcions: [Transaction]) -> Balance {
        let reduced = transatcions.reduce(Decimal(), {
            let isIncome = $1.category?.isIncome ?? true
            return $0 + $1.amount!.decimalValue*(isIncome ? 1 : (-1))
        })
        guard
            var balance = numberFormatter.string(from: reduced as NSNumber),
            var currencySymbol = numberFormatter.currencySymbol,
            let currencyDecimalSeparator = numberFormatter.currencyDecimalSeparator,
            balance.components(separatedBy: currencyDecimalSeparator).count == 2 else
        {
            return Balance("\(reduced)", "", reduced)
        }
        
        balance = reduced > 0 ? "+\(balance)" : balance
        balance = balance.replacingOccurrences(of: currencySymbol, with: "")
        
        let components = balance.components(separatedBy: currencyDecimalSeparator)
        if currencySymbol == "RUB" {
            currencySymbol = "₽"
        }
        return Balance(components[0], "\(currencyDecimalSeparator)\(components[1])\(currencySymbol)", reduced)
    }
    
    private func incomePercent(transatcions: [Transaction]) -> Double {
        
        let sumClosure: ((Double, Transaction)->Double) = { $0 + $1.amount!.doubleValue }

        let sumAll = transatcions.reduce(0, sumClosure)
        let sumFiltered = transatcions
            .filter({ $0.category?.isIncome == true })
            .reduce(0, sumClosure)
        
        return sumFiltered/sumAll
    }
    
}
