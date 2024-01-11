//
//  BookingView.swift
//  HotelTestApp
//
//  Created by Михаил Серегин on 09.01.2024.
//

import SwiftUI

struct BookingView: View {
    @ObservedObject var viewModel: BookingViewModel
    @Binding var router: [Routing]
    var body: some View {
        List {
            // Hotel
            Section {
                VStack(alignment: .leading, spacing: 8) {
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
                        .font(.system(size: 22, weight: .medium))
                        .listRowSeparator(.hidden)
                    
                    // Address
                    Button(action: {}) {
                        Text(viewModel.hotelAddress)
                            .multilineTextAlignment(.leading)
                    }
                    .foregroundColor(.link)
                    .font(.system(size: 14, weight: .medium))
                    .buttonStyle(.borderless)
                }
                .listRowSeparator(.hidden)
            }
            
            // Booking info
            Section {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(viewModel.bookingInfo, id: \.self) { info in
                        HStack(alignment: .firstTextBaseline) {
                            Text(info.key.title)
                                .foregroundColor(.textSecondary)
                                .frame(minWidth: 120, alignment: .leading)
                            Text(info.value)
                        }
                        
                    }
                }
                .font(.system(size: 16))
                .multilineTextAlignment(.leading)
                .listRowSeparator(.hidden)
            }
            
            
            // Customer info
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Информация о покупателе")
                        .font(.system(size: 22, weight: .medium))
                    PrimaryTextField(value: $viewModel.phoneNumber)
                        .setTextFieldType(.phone)
                    PrimaryTextField(value: $viewModel.email)
                        .setTextFieldType(.email)
                    
                }
                .listRowSeparator(.hidden)
            }
            // Tourist info
            ForEach($viewModel.tourists) { item in
                Section {
                    TouristView(title:viewModel.getTourisTitle(for: item.wrappedValue) ,model: item)
                        .listRowSeparator(.hidden)
                }
            }
            
            Section {
                HStack {
                    Text("Добавить туриста")
                        .font(.system(size: 22, weight: .medium))
                    Spacer()
                    Button(action: viewModel.addTourist) {
                        Image(systemName: "plus")
                            .bold()
                    }
                    .padding(8)
                    .background {
                        Color.link
                    }
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                }
                .listRowSeparator(.hidden)
            }
            // PriceInfo
            Section {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Тур")
                            .foregroundColor(.textSecondary)
                        Spacer()
                        Text(viewModel.getPrice(for: viewModel.tourPrice))
                    }
                    
                    HStack {
                        Text("Топливный сбор")
                            .foregroundColor(.textSecondary)
                        Spacer()
                        Text(viewModel.getPrice(for: viewModel.fuelChange))
                    }
                    
                    HStack {
                        Text("Сервисный сбор")
                            .foregroundColor(.textSecondary)
                        Spacer()
                        Text(viewModel.getPrice(for: viewModel.serviceChange))
                    }
                    
                    HStack {
                        Text("К оплате")
                            .foregroundColor(.textSecondary)
                        Spacer()
                        Text(viewModel.getPrice(for: viewModel.totalPrice))
                            .bold()
                            .foregroundColor(.link)
                    }
                }
                .font(.system(size: 16))
                .listRowSeparator(.hidden)
            }
            
            Section {
                Button(action: {router.append(.finish)}) {
                    HStack {
                        Spacer()
                        Text("Оплатить \(viewModel.getPrice(for: viewModel.totalPrice))")
                        Spacer()
                    }
                }
                .disabled(!viewModel.isValid())
                .foregroundColor(.white)
                .padding(.vertical, 15)
                .background { Color.link }
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .listSectionSpacing(8)
        .background {
            Color.background
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}

#Preview {
    BookingView(viewModel: .init(), router: .constant([]))
}
