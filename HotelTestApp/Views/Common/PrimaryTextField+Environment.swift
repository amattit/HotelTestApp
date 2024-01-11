//
//  PrimaryTextField+Environment.swift
//  HotelTestApp
//
//  Created by Михаил Серегин on 11.01.2024.
//

import Foundation
import SwiftUI

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
            case .birth, .valid, .passport:
                return .decimalPad
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
        
        func isValid(value: String) -> Bool {
            switch self {
            case .phone:
                return true
            case .email:
                let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
                return emailPred.evaluate(with: value)
            case .firstname:
                return !value.isEmpty && value.count > 1
            case .lastname:
                return !value.isEmpty && value.count > 1
            case .birth:
                return !value.isEmpty && value.count > 1
            case .citizen:
                return !value.isEmpty && value.count > 1
            case .passport:
                return !value.isEmpty && value.count > 3
            case .valid:
                return !value.isEmpty && value.count > 1
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
