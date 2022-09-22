import SwiftUI

struct ChangeDateView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var viewModel: BalanceViewModel
    
    var body: some View {
        VStack {
            topView()
            infoView()
                .padding(top: .i30, bottom: .i30)
            MonthYearPicker(selectedDate: $viewModel.date)
            Spacer()
        }
        .onAppear {
            viewModel.editDateMode = .begin
        }
    }
    
}

private extension ChangeDateView {
    
    @ViewBuilder
    func topView() -> some View {
        HStack {
            Button {
                viewModel.editDateMode = .cancel
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Отменить")
                    .frame(width: 100, alignment: .leading)
            }
            .foregroundColor(.cBlue)
            .font(.p15)
            .padding(leading: .i24)
            
            Spacer()
            
            Text("Дата")
                .font(.p15)
            
            Spacer()
            
            Button {
                viewModel.editDateMode = .end
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Готово")
                    .frame(width: 100, alignment: .trailing)
            }
            .foregroundColor(.cBlue)
            .font(.p15s)
            .padding(trailing: .i24)
        }
    }
    
    @ViewBuilder
    func infoView() -> some View {
        
        HStack {
            
            Text(viewModel.date.toFormat("MMMM yyyy"))
                .font(.p17s)
                .padding(leading: .i24)
            
            Spacer()
            
            HStack {
                
                Button {
                    viewModel.moveToPrevMonth()
                } label: {
                    Image("DatePickerLeft")
                }
                
                Button {
                    viewModel.moveToNextMonth()
                } label: {
                    Image("DatePickerRight")
                }
                .padding(leading: .i24, trailing: .i24)
                .disabled(viewModel.isFutureDate)
            }
        }
    }
    
}
