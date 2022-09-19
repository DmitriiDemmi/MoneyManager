import SwiftUI
import SwiftDate

struct MonthYearPicker: UIViewRepresentable {
    
    let selectedDate: Binding<Date>

    func makeUIView(context: Context) -> UIPickerView {
        let pickerView = UIPickerView(frame: .zero)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.delegate = context.coordinator
        pickerView.dataSource = context.coordinator
        return pickerView
    }
    
    func updateUIView(_ uiView: UIPickerView, context: Context) {
        let date = selectedDate.wrappedValue.dateAt(.startOfMonth)
        context.coordinator.selectRow(uiView: uiView, date: date)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(selectedDate: selectedDate)
    }
    
    final class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        
        typealias Month = (number: Int, symbol: String)
        
        var months: [Month] {
            let monthSymbols = Calendar.current.monthSymbols
            return monthSymbols.compactMap { monthSymbol  -> Month? in
                guard let index = monthSymbols.firstIndex(of: monthSymbol) else {
                    return nil
                }
                return Month(index + 1, monthSymbol)
            }
        }
        
        var years: [Int] {
            (1970...Date().year).map { $0 }
        }
        
        let selectedDate: Binding<Date>

        init(selectedDate: Binding<Date>) {
            self.selectedDate = selectedDate
        }
        
        func selectRow(uiView: UIPickerView, date: Date) {
            guard let yearIndex = years.firstIndex(of: date.year) else {
                return
            }
            let monthIndex = date.month - 1

            uiView.selectRow(monthIndex, inComponent: 0, animated: false)
            uiView.selectRow(yearIndex, inComponent: 1, animated: false)
        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 2
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            component == 0 ? months.count : years.count
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            component == 0 ? months[row].symbol : "\(years[row])"
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

            let yearIndex = pickerView.selectedRow(inComponent: 1)
            let monthIndex = pickerView.selectedRow(inComponent: 0)

            var components = DateComponents()
            components.year = years[yearIndex]
            components.month = months[monthIndex].number
            components.timeZone = TimeZone(identifier: "UTC")
            
            guard var calculatedDate = Calendar.current.date(from: components) else {
                return
            }
            
            let now = Date().dateAt(.startOfMonth)
            if calculatedDate > now {
                calculatedDate = now
                selectRow(uiView: pickerView, date: calculatedDate)
            }
            selectedDate.wrappedValue = calculatedDate
        }
    }
}

