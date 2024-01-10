//
//  HotelViewModel.swift
//  HotelTestApp
//
//  Created by Михаил Серегин on 09.01.2024.
//

import Foundation
import Combine

final class HotelViewModel: ObservableObject {
    @Published var hotel: HotelModel?

    let service = Service.makeMock()
    private let repository = HotelRepository()
    private var disposables = Set<AnyCancellable>()
    
    private static var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        
        return formatter
    }
    
    func onAppear() {
        repository.fetchHotels()
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] response in
                self?.hotel = .init(response: response)
            }
            .store(in: &disposables)
    }
    
    func getPrice() -> String {
        guard 
            let price = self.hotel?.price as? NSNumber,
            let formattedPrice = Self.formatter.string(from: price)
        else {
            return ""
        }
        
        return formattedPrice
    }
}

struct HotelModel {
    let title: String
    let description: String
    let address: String
    let price: Int
    let priceDescription: String
    let images: [String]
    let tags: [String]
    let raiting: String
    let raitingDescription: String
    
    init(response: HotelRs) {
        self.title = response.name
        self.description = response.aboutTheHotel.description
        self.address = response.adress
        self.price = response.minimalPrice
        self.priceDescription = response.priceForIt
        self.images = response.imageUrls
        self.tags = response.aboutTheHotel.peculiarities
        self.raiting = response.rating.description
        self.raitingDescription = response.ratingName
    }
}

struct Service: Identifiable, Hashable {
    let id: UUID
    let icon: String
    let title: String
    let subtitle: String
}

extension Service {
    static func makeMock() -> [Service] {
        [
            .init(id: UUID(), icon: "smile", title: "Удобства", subtitle: "Самое необходимое"),
            .init(id: UUID(), icon: "checkmark.square", title: "Что включено", subtitle: "Самое необходимое"),
            .init(id: UUID(), icon: "xmark.square", title: "Что не включено", subtitle: "Самое необходимое"),
        ]
    }
}
