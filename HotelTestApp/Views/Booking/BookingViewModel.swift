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
    
    @Published var tourPrice = 0
    @Published var fuelChange = 0
    @Published var serviceChange = 0
    
    @Published var phoneNumber = "9269870045"
    @Published var email = "mikhail.a.seregin@gmail.com"
    
    @Published var bookingInfo: [BookingInfo] = []
    
    @Published var tourists: [TouristModel] = [.init(firstname: "", lastname: "", dateOfBirth: Date(), citizen: "", passportNumber: "", passportValudDate: Date())]
    
    var totalPrice: Int = 0
    
    private let repository = HotelRepository()
    private var disposables = Set<AnyCancellable>()
    
    private static var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        
        return formatter
    }
    
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
                
                self?.bookingInfo.append(.init(key: .from, value: response.departure))
                self?.bookingInfo.append(.init(key: .destination, value: response.arrivalCountry))
                self?.bookingInfo.append(.init(key: .dates, value: "\(response.tourDateStart) - \(response.tourDateStop)"))
                self?.bookingInfo.append(.init(key: .nights, value: response.numberOfNights.description))
                self?.bookingInfo.append(.init(key: .hotel, value: response.hotelName))
                self?.bookingInfo.append(.init(key: .room, value: response.room))
                self?.bookingInfo.append(.init(key: .inclusive, value: response.nutrition))
                
                self?.tourPrice = response.tourPrice
                self?.fuelChange = response.fuelCharge
                self?.serviceChange = response.serviceCharge
                self?.totalPrice = response.tourPrice + response.fuelCharge + response.serviceCharge
            }
            .store(in: &disposables)
    }
    
    func getPrice(for item: Int) -> String {
        let price = item as NSNumber
        guard
            let formattedPrice = Self.formatter.string(from: price)
        else {
            return ""
        }
        
        return formattedPrice + " ₽"
    }
    
    func addTourist() {
        tourists.append(.init(firstname: "", lastname: "", dateOfBirth: Date(), citizen: "", passportNumber: "", passportValudDate: Date()))
    }
    
}

extension BookingViewModel {
    struct BookingInfo: Hashable {
        let key: BookingKey; enum BookingKey {
            case from, destination, dates, nights, hotel, room, inclusive
        }
        let value: String
    }
}

extension BookingViewModel.BookingInfo.BookingKey {
    var title: String {
        switch self {
        case .from:
            return "Вылет из"
        case .destination:
            return "Страна, город"
        case .dates:
            return "Даты"
        case .nights:
            return "Кол-во ночей"
        case .hotel:
            return "Отель"
        case .room:
            return "Номер"
        case .inclusive:
            return "Питание"
        }
    }
}
