//
//  HotelView.swift
//  HotelTestApp
//
//  Created by Михаил Серегин on 09.01.2024.
//

import SwiftUI

enum Routing: Hashable {
    case rooms
    case booking
    case finish
}
struct HotelView: View {
    @ObservedObject var viewModel: HotelViewModel
    @State var router: [Routing] = []
    
    var body: some View {
        NavigationStack(path: $router) {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        TabView {
                            ForEach(viewModel.hotel?.images ?? [], id: \.self) { image in
                                AsyncImage(url: URL(string: image)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    ProgressView()
                                }
                                
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .always))
                        .frame(minHeight: 257)
                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                        
                        // Rating
                        HStack {
                            Image(systemName: "star.fill")
                            Text(viewModel.hotel?.raiting ?? "")
                            Text(viewModel.hotel?.raitingDescription ?? "")
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 7)
                        .foregroundColor(.rating)
                        .background(Color.ratingBg)
                        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                        .padding(.top, 8)
                        
                        
                        // Hotel Name
                        Text(viewModel.hotel?.title ?? "")
                            .font(.system(size: 22, weight: .bold))
                            .listRowSeparator(.hidden)
                        
                        // Address
                        Button(action: {}) {
                            Text(viewModel.hotel?.address ?? "")
                                .multilineTextAlignment(.leading)
                        }
                        .foregroundColor(.link)
                        .font(.system(size: 14, weight: .bold))
                        .buttonStyle(.borderless)
                        
                        // Price
                        HStack(alignment: .firstTextBaseline) {
                            Text("от \(viewModel.getPrice()) ₽")
                            Text(viewModel.hotel?.priceDescription ?? "")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.textSecondary)
                        }
                        .font(.system(size: 30, weight: .bold))
                        .padding(.top, 8)
                    }
                }
                .listRowSeparator(.hidden)
                
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Об отеле")
                            .font(.system(size: 22, weight: .bold))
                        
                        // Теги
                        CollectionView(data: viewModel.hotel?.tags ?? []) { tag in
                            Text(tag)
                                .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                                .background { Color.bacgroundSecondary }
                                .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                        }
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color.textSecondary)
                        .padding(.top, 8)
                        
                        // Описание отеля
                        Text(viewModel.hotel?.description ?? "")
                            .font(.system(size: 16, weight: .regular))
                            .padding(.top, 6)
                        
                        // Список удобств
                        VStack {
                            ForEach(viewModel.service) { service in
                                Button(action: {}) {
                                    ServiceView(service: service)
                                }
                                .buttonStyle(.borderless)
                                if service != viewModel.service.last {
                                    Divider()
                                        .padding(.leading, 32)
                                }
                            }
                        }
                        .padding()
                        .background {
                            Color.bacgroundSecondary
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                        .padding(.top, 8)
                    }
                }
                .listRowSeparator(.hidden)
                .listSectionSpacing(.compact)
                
                Section {
                    Button(action: {self.router.append(.rooms)}) {
                        HStack {
                            Spacer()
                            Text("К выбору номера")
                            Spacer()
                        }
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 15)
                    .background { Color.link }
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                }
                
            }
            .listStyle(.plain)
            .background(Color.background)
            .onAppear {
                viewModel.onAppear()
            }
            .navigationTitle("Отель")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Routing.self) { route in
                switch route {
                case .rooms:
                    if let hotel = viewModel.hotel {
                        RoomsView(viewModel: .init(hotelModel: hotel), router: $router)
                    }
                case .booking:
                    BookingView(viewModel: .init(), router: $router)
                case .finish:
                    SuccessView(router: $router)
                }
            }
        }
    }
}

struct ServiceView: View {
    let service: Service
    var body: some View {
        HStack {
            Image(service.icon)
                .resizable()
                .frame(width: 24, height: 24)
            VStack(alignment: .leading) {
                Text(service.title)
                Text(service.subtitle)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.textSecondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
        }
        .font(.system(size: 16, weight: .regular))
        .foregroundColor(.primary)
    }
}

#Preview {
    HotelView(viewModel: .init())
}

extension String: Identifiable {
    public var id: String {
        self
    }
}
