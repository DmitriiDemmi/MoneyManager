//
//  CreateLoanView.swift
//  MoneyManager
//
//  Created by Aleksey Nikolaenko on 20.09.2022.
//

import SwiftUI
import CoreData

struct CreateLoanView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State var loanAmount: String = ""
    @State var personName: String = ""
    @State var returnDate: Date = Date()
    
    @State var enableNotification = false
    
    @State var showErrorAlert = false
    @State var error: NSError?
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                FormView(
                    loanAmount: $loanAmount,
                    personName: $personName,
                    returnDate: $returnDate,
                    enableNotification: $enableNotification
                )
                Spacer().frame(width: 0, height: 72)
                HStack(spacing: 15) {
                    ActionButton(title: "Я дал") { saveLoan(for: .credits) }
                    ActionButton(title: "Я взял") { saveLoan(for: .loans) }
                }
                Spacer()
            }
            .padding(.horizontal, 24)
        }
        .navigationTitle(
            Text("Добавить долг")
        )
    }
    
    func createLoan(notification: Bool) -> LoansPerson {
        let person = NSEntityDescription.insertNewObject(forEntityName: "LoansPerson", into: managedObjectContext) as! LoansPerson
        person.personID = UUID()
        person.name = personName
        person.amount = 0
        person.date = returnDate
        person.image = nil
        return person
    }
    
    func saveLoan(for category: LoanCategories) {
        let person = createLoan(notification: enableNotification)
        do {
            let categories = try managedObjectContext.fetch(NSFetchRequest<LoansCategory>(entityName: "LoansCategory"))
            person.category = categories.first(where: { $0.categoryID == category.rawValue})
            try managedObjectContext.save()
        } catch(let error) {
            //FIXME: Хорошо бы сделать алерт на эту ошибку
            print(error)
        }
    }
    
}

private struct ActionButton: View {
    
    @State var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text(title)
                    .font(.body.weight(.semibold))
                    .foregroundColor(.white)
                    .padding(15)
                Spacer()
            }
            .background(Color(.sRGB, red: 56/255, green: 58/255, blue: 209/255, opacity: 1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

private struct FormView: View {
    
    enum FocusedField {
        case loanAmount, personName, returnDate
    }
    
    @FocusState private var focusedState: FocusedField?
    @Binding var loanAmount: String
    @Binding var personName: String
    @Binding var returnDate: Date
    @Binding var enableNotification: Bool
    
    var body: some View {
        VStack(spacing: 36) {
            FieldView(id: .loanAmount, plaсeholder: "Сумма долга", value: $loanAmount, focusedState: _focusedState)
                .onSubmit { focusedState = .personName }
            FieldView(id: .personName, plaсeholder: "ФИО", value: $personName, focusedState: _focusedState)
                .onSubmit { focusedState = nil }
            
            DatePicker(selection: $returnDate, in: Date()..., displayedComponents: [.date, .hourAndMinute]) {
                Text("Дата возврата")
                    .font(.body)
                    .foregroundColor(.black.opacity(0.54))
            }
//            .datePickerStyle(GraphicalDatePickerStyle())
            
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
            .background(Color(.sRGB, red: 245/255, green: 245/255, blue: 245/255, opacity: 1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            Toggle(isOn: $enableNotification) {
                Text("Мне необходимо прислать PUSH-напоминание о долге")
                    .font(.caption)
                    .foregroundColor(.black.opacity(0.54))
                Spacer()
            }
        }
    }
    
}

private struct FieldView: View {
    var id: FormView.FocusedField
    @State var plaсeholder: String
    @Binding var value: String
    @FocusState var focusedState: FormView.FocusedField?
    
    var body: some View {
        ZStack(alignment: .leading) {
            SwiftUI.TextField("", text: $value)
                .textFieldStyle(DSRoundedRectangleTextFieldStyle())
                .focused($focusedState, equals: id)
            if value.isEmpty {
                Text(plaсeholder)
                    .padding()
                    .padding(.leading, 3)
                    .font(.body)
                    .foregroundColor(.black.opacity(0.54))
            }
        }.onTapGesture { focusedState = id }
        
    }
}

struct DSRoundedRectangleTextFieldStyle: TextFieldStyle {
    
    func _body(configuration: SwiftUI.TextField<Self._Label>) -> some View {
        configuration
            .padding(.vertical, 20)
            .padding(.horizontal, 16)
            .background(Color(.sRGB, red: 245/255, green: 245/255, blue: 245/255, opacity: 1))
            .cornerRadius(12)
    }
    
}

struct CreateLoanView_Previews: PreviewProvider {
    static var previews: some View {
        CreateLoanView()
    }
}
