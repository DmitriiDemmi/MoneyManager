import CoreData
import SwiftUI
import SwiftDate

struct BalanceView: View {
    
    enum BalanceViewStyle {
        case short
        case full
    }
    
    static let heightForShort: CGFloat = 90
    static let heightForFull: CGFloat = 130
    
    let style: BalanceViewStyle
    
    @FetchRequest(sortDescriptors: []) private var transatcions: FetchedResults<Transaction>
    
    @StateObject private var viewModel = BalanceViewModel()
    
    @State private var showingSheet = false
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            let result = viewModel.calc(transatcions: transatcions)
            
            HStack {
                Text("Баланс за")
                    .font(.p15)
                    .foregroundColor(.cGray)
                    .padding(leading: .i24)
                
                Button(viewModel.currentMonthName) {
                    showingSheet = true
                }
                .font(style == .short ? .p15s : .p15)
                .foregroundColor(style == .short ? .cBlue : .cGray)
                .disabled(style == .full)
                .sheet(isPresented: $showingSheet) {
                    ChangeDateView()
                        .environmentObject(viewModel)
                        .padding(top: .i30)
                }
                
                Spacer()
            }
            
            HStack(spacing: 0) {
                Text(result.balance.whole)
                    .frame(alignment: .leading)
                    .font(.p52s)
                    .padding(top: .i4, leading: .i24)
                
                if let remainder = result.balance.remainder {
                    Text(remainder)
                        .foregroundColor(.cGray)
                        .frame(alignment: .leading)
                        .font(.p40)
                        .padding(top: .i12)
                }
                Spacer()
            }
            
            let isShowProgress = style == .full && result.balance.raw != 0
            if isShowProgress {
                VStack {
                    ProgressView(progress: result.percent)
                        .frame(height: 8)
                        .padding(top: .i6, leading: .i24, trailing: .i24)
                    
                    HStack {
                        Text(result.isGoodIncome ? "Все отлично!" : "Вы транжира :-)")
                            .font(.p12)
                            .foregroundColor(result.isGoodIncome ? .cGreen : .cRed)
                            .padding(top: .i2, leading: .i24)
                        Spacer()
                    }
                }
            }
            
            Spacer()
        }
    }
    
    
}

extension BalanceView {
    
    static func makeViewController(style: BalanceViewStyle, viewContext: NSManagedObjectContext) -> UIViewController {
        let balanceView = BalanceView(style: style)
            .environment(\.managedObjectContext, viewContext)
        return UIHostingController(rootView: balanceView)
    }
    
    static func makeView(style: BalanceViewStyle, viewContext: NSManagedObjectContext) -> UIView {
        makeViewController(style: style, viewContext: viewContext).view
    }
    
}

struct BalanceView_Previews: PreviewProvider {
    static var previews: some View {
        BalanceView(style: .full)
    }
}
