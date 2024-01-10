//
//  BookingView.swift
//  HotelTestApp
//
//  Created by Михаил Серегин on 09.01.2024.
//

import SwiftUI

struct BookingView: View {
    @ObservedObject var viewModel: BookingViewModel
    
    var body: some View {
        ScrollView {
            // Rating
            HStack {
                Image(systemName: "star.fill")
                Text(viewModel.rating)
                Text(viewModel.ratingTitle)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .foregroundColor(.rating)
            .background(Color.ratingBg)
            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
            .padding(.top, 8)
            
            
            // Hotel Name
            Text(viewModel.hotelTitle)
                .font(.system(size: 22, weight: .bold))
                .listRowSeparator(.hidden)
            
            // Address
            Button(action: {}) {
                Text(viewModel.hotelAddress)
                    .multilineTextAlignment(.leading)
            }
            .foregroundColor(.link)
            .font(.system(size: 14, weight: .bold))
            .buttonStyle(.borderless)
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}
