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
                    .font(.system(size: 14, weight: .bold))
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
            }
            // Tourist info
            Section {
                VStack {
                    ForEach($viewModel.tourists, id: \.self) { item in
                        TouristView(model: item)
                    }
                }
                .listRowSeparator(.hidden)
            }
            
            Section {
                HStack {
                    Text("Добавить туриста")
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
                }
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
    BookingView(viewModel: .init())
}

struct PrimaryTextField: View {
    @Environment(\.textFieldType) var type
    @Binding var value: String
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if type.isTopLabled {
                Text(type.title)
                    .font(.system(size: 12))
                    .foregroundColor(.textSecondary)
            }
            TextField(type.isTopLabled ? "" : type.title, value: $value, formatter: type.formatter)
        }
        .keyboardType(type.keyboardType)
        .padding(.init(top: 10, leading: 16, bottom: 10, trailing: 16))
        .background {
            Color.background
        }
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

extension PrimaryTextField {
    enum FieldType {
        case phone, email, firstname, lastname
        case  birth, citizen, passport, valid
        
        var title: String {
            switch self {
            case .phone:
                return "Номер телефона"
            case .email:
                return "Почта"
            case .firstname:
                return "Имя"
            case .lastname:
                return "Фамилия"
            case .birth:
                return "Дата рождения"
            case .citizen:
                return "Гражданство"
            case .passport:
                return "Номер загранпаспорта"
            case .valid:
                return "Срок действия загранпаспорта"
            }
        }
        
        var formatter: Formatter {
            switch self {
            case .phone:
                return PhoneNumberFormatter()
            default:
                return DefaultFormatter()
            }
        }
        
        var keyboardType: UIKeyboardType {
            switch self {
            case .phone:
                    return .phonePad
            case .email:
                return .emailAddress
            default:
                return .default
            }
        }
        
        var isTopLabled: Bool {
            switch self {
            case .phone, .email, .firstname, .lastname:
                return true
            default:
                return false
            }
        }
    }
    
    struct PrimaryTextFieldKey: EnvironmentKey {
        static var defaultValue: FieldType = .phone
    }
    
    func setTextFieldType(_ type: FieldType) -> some View {
        environment(\.textFieldType, type)
    }
}


extension EnvironmentValues {
    var textFieldType: PrimaryTextField.FieldType {
        get { self[PrimaryTextField.PrimaryTextFieldKey.self] }
        set { self[PrimaryTextField.PrimaryTextFieldKey.self] = newValue }
    }
}

// TODO: FIXME
class PhoneNumberFormatter: Formatter {
    override func string(for obj: Any?) -> String? {
        if let string = obj as? String {
            return formatted(string)
        }
        return nil
    }
    
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        obj?.pointee = string as AnyObject?
        return true
    }
    
    func formatted(_ item: String?) -> String? {
        guard let number = item else { return nil }
        let mask = "+7 (***) ***-**-**"
        var result = ""
        var index = number.startIndex
        for ch in mask where index < number.endIndex {
            if ch == "*" {
                result.append(number[index])
                index = number.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
}

class DefaultFormatter: Formatter {
    override func string(for obj: Any?) -> String? {
        if let string = obj as? String {
            return string
        }
        return nil
    }
    
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        obj?.pointee = string as AnyObject?
        return true
    }
}
