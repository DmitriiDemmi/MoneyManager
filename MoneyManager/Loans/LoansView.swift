//
//  LoansView.swift
//  MoneyManager
//
//  Created by Aleksey Nikolaenko on 16.09.2022.
//

import SwiftUI
import CoreData

struct LoansView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(
        entity: LoansCategory.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \LoansCategory.categoryID, ascending: true)
        ]
    ) var sections: FetchedResults<LoansCategory>
    
    var body: some View {
        ContentView(categories: sections.compactMap{$0})
    }
}

private struct ContentView: View {
    
    @State var categories: [LoansCategory]
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                VStack {
                    ForEach(categories, id: \.title) { (category) in
                        HeaderView(text: category.title)
                        LazyVGrid(columns: [
                            GridItem(.adaptive(minimum: 74, maximum: 94))
                        ]) {
                            if let persons = category.persons?.array as? [LoansPerson] {
                                ForEach(persons, id: \.personID) {
                                    PersonView(person: $0)
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { NavigationBarView() }
        }
    }
    
}

private struct NavigationBarView: View {
    
    @State var isActive = false
    
    var body: some View {
        HStack {
            Spacer()
            NavigationLink(destination: CreateLoanView().environment(\.managedObjectContext, CoreDataService.shared.persistentContainer(for: .loans).viewContext)) {
                HStack {
                    Text("Добавить долг")
                }
            }
            .buttonStyle(.plain)
        }
    }
}

private struct HeaderView: View {
    
    @State var text: String?
    
    var body: some View {
        HStack {
            Text(text ?? "")
                .font(.title3.weight(.semibold))
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 32)
        .padding(.bottom, 16)
    }
    
}

private struct PersonView: View {
    
    @State var person: LoansPerson?
    
    var body: some View {
        VStack {
            Text(person?.name ?? "")
                .multilineTextAlignment(.center)
                .font(.footnote.weight(.medium))
            if let data = person?.image, let image = UIImage(data: data) {
                Text("nil")
            } else {
                ZStack {
                    Circle()
                        .frame(width: 42, height: 42, alignment: .center)
                        .foregroundColor(Color(.sRGB, red: 56/255, green: 58/255, blue: 209/255, opacity: 1))
                    Text(iconSymbols(from: person?.name))
                        .font(.system(size: 10).bold())
                        .foregroundColor(.white)
                }
            }
            Text(format(person?.amount))
                .foregroundColor(Color(.sRGB, red: 56/255, green: 58/255, blue: 209/255, opacity: 1))
                .font(.footnote.weight(.medium))
        }
    }
    
    func format(_ number: NSNumber?) -> String {
        guard let number = number else { return "" }
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = ","
        return formatter.string(from: number) ?? ""
    }
    
    func iconSymbols(from name: String?) -> String {
        guard let name = name else { return "" }
        return name
            .split(separator: " ")
            .compactMap {
                guard let chr = $0.first else { return nil }
                return String(chr)
            }
            .joined()
    }
    
}

struct LoansView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataService.shared.persistentContainer(for: .loans).viewContext
        let myLoans = LoansCategory(context: context)
        myLoans.categoryID = LoanCategories.loans.rawValue
        myLoans.title = "Я взял"
        
        let myCredits = LoansCategory(context: context)
        myCredits.categoryID = LoanCategories.credits.rawValue
        myCredits.title = "Я дал"
        
        let person = LoansPerson(context: context)
        person.category = myLoans
        person.amount = 1000
        person.name = "Кто-то"
        
        let person5 = LoansPerson(context: context)
        person5.personID = UUID()
        person5.category = myLoans
        person5.name = "Наталья ijerfv eiurvie akjfviiuevo"
        person5.amount = 200000000
        
        let person2 = LoansPerson(context: context)
        person2.personID = UUID()
        person2.category = myLoans
        person2.name = "Наталья Чевапчичи"
        person2.amount = 2000
        
        let person7 = LoansPerson(context: context)
        person7.personID = UUID()
        person7.category = myLoans
        person7.name = "Наталья Чевапчичи 3"
        person7.amount = 2000
        
        let person4 = LoansPerson(context: context)
        person4.personID = UUID()
        person4.category = myLoans
        person4.name = "Наталья"
        person4.amount = 20000
        
        
        
        let person3 = LoansPerson(context: context)
        person3.personID = UUID()
        person3.category = myCredits
        person3.name = "Игорь"
        person3.amount = 500
        
        do {
            try context.save()
        } catch {
            print("error")
        }
        
        return ContentView(categories: [
            myLoans, myCredits
        ])
    }
}
