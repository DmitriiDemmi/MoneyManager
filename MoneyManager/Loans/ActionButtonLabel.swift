//
//  ActionButtonLabel.swift
//  MoneyManager
//
//  Created by Aleksey Nikolaenko on 23.09.2022.
//

import SwiftUI

struct ActionButtonLabel: View {
    
    @State var title: String
    
    var body: some View {
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
}
