//
//  TouristView.swift
//  HotelTestApp
//
//  Created by Михаил Серегин on 10.01.2024.
//

import SwiftUI

struct TouristView: View {
    let title: String
    @Binding var model: TouristModel

    @State var expanded = true
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(title)
                Spacer()
                Button(action: {
                    expanded.toggle()
                }) {
                    Image(systemName: "chevron.down")
                        .foregroundColor(.link)
                        .rotationEffect(expanded ? .zero : .degrees(-180))
                }
                .buttonStyle(.borderless)
                .padding(8)
                .background { Color.link.opacity(0.1)}
            }
                .font(.system(size: 22, weight: .medium))
            if expanded {
                PrimaryTextField(value: $model.firstname)
                    .setTextFieldType(.firstname)
                PrimaryTextField(value: $model.lastname)
                    .setTextFieldType(.lastname)
                PrimaryTextField(value: $model.dateOfBirth)
                    .setTextFieldType(.birth)
                PrimaryTextField(value: $model.citizen)
                    .setTextFieldType(.citizen)
                PrimaryTextField(value: $model.passportNumber)
                    .setTextFieldType(.passport)
                PrimaryTextField(value: $model.passportValudDate)
                    .setTextFieldType(.valid)
            }
        }
    }
}

struct TouristModel: Hashable,Identifiable {
    let id = UUID()
    var firstname: String
    var lastname: String
    var dateOfBirth: String
    var citizen: String
    var passportNumber: String
    var passportValudDate: String
    
    var isValidData: Bool {
        !firstname.isEmpty && firstname.count > 1
        && !lastname.isEmpty && lastname.count > 1
        && !citizen.isEmpty
        && !passportNumber.isEmpty && passportNumber.count > 3
    }
}
