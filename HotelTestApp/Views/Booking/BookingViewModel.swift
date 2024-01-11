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
    
    @Published var tourists: [TouristModel] = [.init(firstname: "", lastname: "", dateOfBirth: "", citizen: "", passportNumber: "", passportValudDate: "")]
    
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
        tourists.append(.init(firstname: "", lastname: "", dateOfBirth: "", citizen: "", passportNumber: "", passportValudDate: ""))
    }
    
    func getTourisTitle(for model: TouristModel) -> String {
        let index = (tourists.firstIndex(of: model) ?? 0) + 1
        switch index {
        case 1:
            return "Первый турист"
        case 2:
            return "Второй турист"
        case 3:
            return "Третий турист"
        case 4:
            return "Четвертый турист"
        case 5:
            return "Пятый турист"
        case 6:
            return "Шестой турист"
        case 7:
            return "Седьмой турист"
        case 8:
            return "Восьмой турист"
        case 9:
            return "Девятый турист"
        case 10:
            return "Десятый турист"
        case 11:
            return "Одинадцатый турист"
        case 12:
            return "Двенадцатый турист"
        case 13:
            return "Тринадцатый турист"
        default:
            return "N+1 турист"
        }
    }
    
    func isValid() -> Bool {
        tourists.allSatisfy { $0.isValidData }
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
