//
//  Formatters.swift
//  HotelTestApp
//
//  Created by Михаил Серегин on 11.01.2024.
//

import Foundation

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
