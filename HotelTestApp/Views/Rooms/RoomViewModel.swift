//
//  RoomViewModel.swift
//  HotelTestApp
//
//  Created by Михаил Серегин on 09.01.2024.
//

import Foundation
import Combine

final class RoomViewModel: ObservableObject {
    @Published var roomResponse: [RoomRs] = []

    let hotelModel: HotelModel

    private let repository = HotelRepository()
    private var disposables = Set<AnyCancellable>()
    
    private static var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        
        return formatter
    }
    init(hotelModel: HotelModel) {
        self.hotelModel = hotelModel
    }
    
    func onAppear() {
        repository.fetchRooms().sink { completion in
            if case let .failure(error) = completion {
                print(error.localizedDescription)
            }
        } receiveValue: { [weak self] response in
            self?.roomResponse = response.rooms
        }
        .store(in: &disposables)

    }
    
    func getPrice(for room: RoomRs) -> String {
        let price = room.price as NSNumber
        guard
            let formattedPrice = Self.formatter.string(from: price)
        else {
            return ""
        }
        
        return formattedPrice
    }
}
