//
//  PrimaryTextField.swift
//  HotelTestApp
//
//  Created by Михаил Серегин on 11.01.2024.
//

import SwiftUI

struct PrimaryTextField: View {
    @Environment(\.textFieldType) var type
    @Binding var value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if type.isTopLabled {
                Text(type.title)
                    .font(.system(size: 12))
                    .foregroundColor(.textSecondary)
            }
            TextField(type.isTopLabled ? "" : type.title, value: $value, formatter: type.formatter)
        }
        .keyboardType(type.keyboardType)
        .padding(.init(top: 10, leading: 16, bottom: 10, trailing: 16))
        .background {
            type.isValid(value: value) ? Color.background : .error
        }
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}
