//
//  HotelRepository.swift
//  HotelTestApp
//
//  Created by Михаил Серегин on 09.01.2024.
//

import Networking
import Foundation
import Combine

// MARK: Repository
/// Репозиторий, чтобы получать данные с сервера заглушек
struct HotelRepository: WebRepository {
    var baseURL: String = "https://run.mocky.io/v3"
    
    var queue = DispatchQueue(label: "Networking", attributes: [.concurrent])
    
    var session: URLSession = .shared
    
    func fetchHotels() -> AnyPublisher<HotelRs, Error> {
        call(endpoint: API.getHotel, errorType: ServerErrorRs.self)
    }
    
    func fetchRooms() -> AnyPublisher<RoomsRs, Error> {
        call(endpoint: API.rooms, errorType: ServerErrorRs.self)
    }
    
    func fetchBookingInfo() -> AnyPublisher<BookingRs, Error> {
        call(endpoint: API.booking, errorType: ServerErrorRs.self)
    }
}


// MARK: API
/// Описание всех API
enum API: APICall {
    /// Получить данные об отеле
    case getHotel
    
    /// Получить данные о номерах в отеле
    case rooms
    
    /// Получение данных для бронирования
    case booking
    
    var path: String {
        switch self {
        case .getHotel:
            return "/d144777c-a67f-4e35-867a-cacc3b827473"
        case .rooms:
            return "/8b532701-709e-4194-a41c-1a903af00195"
        case .booking:
            return "/63866c74-d593-432c-af8e-f279d1a8d2ff"
        }
    }
    
    var method: String {
        "GET"
    }
    
    var headers: [String : String]? {
        ["Content-Type": "application/json"]
    }
    
    var query: [String : String]? {
        nil
    }
    
    func body() throws -> Data? {
        nil
    }
}

// MARK: Response Data
// MARK: - Hotel
struct HotelRs: Codable {
    let id: Int
    let name, adress: String
    let minimalPrice: Int
    let priceForIt: String
    let rating: Int
    let ratingName: String
    let imageUrls: [String]
    let aboutTheHotel: AboutTheHotelRs

    enum CodingKeys: String, CodingKey {
        case id, name, adress
        case minimalPrice = "minimal_price"
        case priceForIt = "price_for_it"
        case rating
        case ratingName = "rating_name"
        case imageUrls = "image_urls"
        case aboutTheHotel = "about_the_hotel"
    }
}

// MARK: - AboutTheHotel
struct AboutTheHotelRs: Codable {
    let description: String
    let peculiarities: [String]
}

// MARK: - Rooms
struct RoomsRs: Codable {
    let rooms: [RoomRs]
}

// MARK: - Room
struct RoomRs: Codable, Identifiable {
    let id: Int
    let name: String
    let price: Int
    let pricePer: String
    let peculiarities: [String]
    let imageUrls: [String]

    enum CodingKeys: String, CodingKey {
        case id, name, price
        case pricePer = "price_per"
        case peculiarities
        case imageUrls = "image_urls"
    }
}


// MARK: - Booking
struct BookingRs: Codable {
    let id: Int
    let hotelName, hotelAdress: String
    let horating: Int
    let ratingName, departure, arrivalCountry, tourDateStart: String
    let tourDateStop: String
    let numberOfNights: Int
    let room, nutrition: String
    let tourPrice, fuelCharge, serviceCharge: Int

    enum CodingKeys: String, CodingKey {
        case id
        case hotelName = "hotel_name"
        case hotelAdress = "hotel_adress"
        case horating
        case ratingName = "rating_name"
        case departure
        case arrivalCountry = "arrival_country"
        case tourDateStart = "tour_date_start"
        case tourDateStop = "tour_date_stop"
        case numberOfNights = "number_of_nights"
        case room, nutrition
        case tourPrice = "tour_price"
        case fuelCharge = "fuel_charge"
        case serviceCharge = "service_charge"
    }
}

struct ServerErrorRs: Codable {
    let error: String?
}
