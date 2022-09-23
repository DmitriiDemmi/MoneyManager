//
//  CreateLoanView.swift
//  MoneyManager
//
//  Created by Aleksey Nikolaenko on 20.09.2022.
//

import SwiftUI
import CoreData

struct CreateLoanView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var loanAmount: String = ""
    @State private var personName: String = ""
    @State private var returnDate: Date = Date()
    @State private var imageData: Data?
    @State private var enableNotification = false
    @State private var invalidFields: Set<FormView.FocusedField> = []
    @State private var showErrorAlert = false
    @State private var error: NSError?
    
    var addPersonDelegate: ((_ category: LoanCategories, _ name: String, _ amount: NSDecimalNumber, _ returnDate: Date, _ image: Data?, _ enableNotification: Bool) -> Void)?
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                FormView(
                    loanAmount: $loanAmount,
                    personName: $personName,
                    returnDate: $returnDate,
                    enableNotification: $enableNotification,
                    invalidFields: $invalidFields
                )
                Spacer().frame(width: 0, height: 72)
                HStack(spacing: 15) {
                    ActionButton(title: "Я дал") { action(for: .credits) }
                    ActionButton(title: "Я взял") { action(for: .loans) }
                }
                Spacer()
            }
            .padding(.horizontal, 24)
        }
        .navigationTitle(
            Text("Добавить долг")
        )
    }
    
    func action(for category: LoanCategories) {
        guard validateFields() else { return }
        addPersonDelegate?(category, personName, NSDecimalNumber(string: loanAmount), returnDate, imageData, enableNotification)
        presentationMode.wrappedValue.dismiss()
    }
    
    func validateFields() -> Bool {
        var isValid = true
        invalidFields = []
        if personName.isEmpty {
            isValid = false
            invalidFields.insert(.personName)
        }
        if loanAmount.isEmpty, NSDecimalNumber(string: loanAmount) == NSDecimalNumber.notANumber {
            isValid = false
            invalidFields.insert(.loanAmount)
        }
        return isValid
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
    
    @Binding var invalidFields: Set<FocusedField>
    
    var body: some View {
        VStack(spacing: 36) {
            FieldView(id: .loanAmount, plaсeholder: "Сумма долга", value: $loanAmount, invalidFields: $invalidFields, focusedState: _focusedState)
                .onSubmit { focusedState = .personName }
                .keyboardType(.decimalPad)
            FieldView(id: .personName, plaсeholder: "ФИО", value: $personName, invalidFields: $invalidFields, focusedState: _focusedState)
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
    @Binding var invalidFields: Set<FormView.FocusedField>
    @FocusState var focusedState: FormView.FocusedField?
    
    var body: some View {
        ZStack(alignment: .leading) {
            SwiftUI.TextField("", text: $value)
                .onChange(of: value) { newValue in
                    if focusedState == id {
                        invalidFields.remove(id)
                    }
                }
                .textFieldStyle(DSRoundedRectangleTextFieldStyle())
                .background(invalidFields.contains(id) ? Color.red.opacity(0.54) : Color(.sRGB, red: 245/255, green: 245/255, blue: 245/255, opacity: 1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
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
    }
    
}

struct CreateLoanView_Previews: PreviewProvider {
    static var previews: some View {
        CreateLoanView() { (category, name, amount, returnDate, image, enableNotification)  in }
    }
}
