//
//  SuccessView.swift
//  HotelTestApp
//
//  Created by Михаил Серегин on 11.01.2024.
//

import SwiftUI

struct SuccessView: View {
    @Binding var router: [Routing]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 20) {
                Spacer()
                Image("success")
                Text("Ваш заказ принят в работу")
                    .font(.system(size: 22, weight: .medium))
                    .padding(.top, 12)
                Text("Подтверждение заказа №104893 может занять некоторое время (от 1 часа до суток). Как только мы получим ответ от туроператора, вам на почту придет уведомление.")
                    .font(.system(size: 16))
                    .foregroundColor(.textSecondary)
                Spacer()
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, 23)
            
            Button(action: {router.removeAll()}) {
                HStack {
                    Spacer()
                    Text("Супер!")
                    Spacer()
                }
            }
            .foregroundColor(.white)
            .padding(.vertical, 15)
            .background { Color.link }
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            .padding(.horizontal, 16)
        }
        .padding(.bottom)
    }
}

#Preview {
    SuccessView(router: .constant([]))
}
