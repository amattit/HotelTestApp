//
//  TouristView.swift
//  HotelTestApp
//
//  Created by Михаил Серегин on 10.01.2024.
//

import SwiftUI

struct TouristView: View {
    @Binding var model: TouristModel
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            PrimaryTextField(value: $model.firstname)
                .setTextFieldType(.firstname)
            PrimaryTextField(value: $model.lastname)
                .setTextFieldType(.lastname)
//            PrimaryTextField(value: $model.dateOfBirth)
            PrimaryTextField(value: $model.citizen)
                .setTextFieldType(.citizen)
            PrimaryTextField(value: $model.passportNumber)
                .setTextFieldType(.passport)
//            PrimaryTextField(value: $model.passportValudDate)
            
        }
    }
}

struct TouristModel: Hashable {
    var firstname: String
    var lastname: String
    var dateOfBirth: Date
    var citizen: String
    var passportNumber: String
    var passportValudDate: Date
}
