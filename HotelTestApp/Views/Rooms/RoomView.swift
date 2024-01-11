//
//  RoomView.swift
//  HotelTestApp
//
//  Created by Михаил Серегин on 09.01.2024.
//

import SwiftUI

struct RoomsView: View {
    @ObservedObject var viewModel: RoomViewModel
    @Binding var router: [Routing]
    var body: some View {
        List {
            ForEach(viewModel.roomResponse) { room in
                Section {
                    VStack(alignment: .leading) {
                        TabView {
                            ForEach(room.imageUrls, id: \.self) { image in
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
                        
                        Text(room.name)
                            .font(.system(size: 22))
                        
                        CollectionView(data: room.peculiarities) { tag in
                            Text(tag)
                                .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                                .background { Color.bacgroundSecondary }
                                .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                        }
                        
                        Button(action: {}) {
                            HStack {
                                Text("Подробнее о номере")
                                Image(systemName: "chevron.right")
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background {
                            Color.link.opacity(0.1)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                        .buttonStyle(.borderless)
                        
                        // Price
                        HStack(alignment: .firstTextBaseline) {
                            Text("\(viewModel.getPrice(for: room)) ₽")
                            Text(room.pricePer)
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.textSecondary)
                        }
                        .font(.system(size: 30, weight: .bold))
                        
                        Button(action: {router.append(.booking)}) {
                            HStack {
                                Spacer()
                                Text("Выбрать номер")
                                Spacer()
                            }
                        }
                        .buttonStyle(.borderless)
                        .foregroundColor(.white)
                        .padding(.vertical, 15)
                        .background { Color.link }
                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    }
                    .padding(.vertical, 16)
                    .listSectionSeparator(.hidden)
                }
            }
            .listSectionSpacing(.compact)
        }
        .listStyle(.plain)
        .background { Color.background }
        .onAppear(perform: {
            viewModel.onAppear()
        })
        .navigationTitle(viewModel.hotelModel.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        RoomsView(viewModel: .init(hotelModel: .init(response: .init(id: 1, name: "123", adress: "3333", minimalPrice: 123323, priceForIt: "asdssadaads", rating: 5, ratingName: "gggg", imageUrls: [], aboutTheHotel: .init(description: "", peculiarities: [])))), router: Binding<[Routing]>.constant([]))
    }
}
