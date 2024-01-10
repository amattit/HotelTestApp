//
//  BookingViewModel.swift
//  HotelTestApp
//
//  Created by Михаил Серегин on 09.01.2024.
//

import Foundation
import Combine

final class BookingViewModel: ObservableObject {
    
    @Published var rating = ""
    @Published var ratingTitle = ""
    @Published var hotelTitle = ""
    @Published var hotelAddress = ""
    @Published var from = ""
    @Published var to = ""
    @Published var dateStart = ""
    @Published var dateEnd = ""
    @Published var numberOfNights = ""
    @Published var roomTitle = ""
    @Published var inclusive = ""
    @Published var tourPrice = ""
    @Published var fuelChange = ""
    @Published var serviceChange = ""
    
    private let repository = HotelRepository()
    private var disposables = Set<AnyCancellable>()
    
    func onAppear() {
        repository.fetchBookingInfo()
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] response in
                self?.rating = response.horating.description
                self?.ratingTitle = response.ratingName
                self?.hotelTitle = response.hotelName
                self?.hotelAddress = response.hotelAdress
            }
            .store(in: &disposables)

    }
}
