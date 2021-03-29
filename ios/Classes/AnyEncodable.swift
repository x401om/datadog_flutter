//
//  AnyEncodable.swift
//  datadog_flutter
//
//  Created by Aleksey Goncharov on 29.03.2021.
//

import Foundation

public struct AnyEncodable: Encodable {
    public let value: Any
    public init<T>(_ value: T?) {
        self.value = value ?? NSNull()
    }

    public init() {
        value = NSNull()
    }

    func isBoolNumber(_ value: Any) -> Bool {
        guard let num = value as? NSNumber else { return false }
        let boolID = CFBooleanGetTypeID() // the type ID of CFBoolean
        let numID = CFGetTypeID(num) // the type ID of num
        return numID == boolID
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch value {
        case is NSNull:
            try container.encodeNil()
        case let bool as Bool where isBoolNumber(value):
            try container.encode(bool)
        case let int as Int:
            try container.encode(int)
        case let double as Double:
            try container.encode(double)
        case let string as String:
            try container.encode(string)
        case let array as [Any?]:
            try container.encode(array.map { AnyEncodable($0) })
        case let dictionary as [String: Any?]:
            try container.encode(dictionary.mapValues { AnyEncodable($0) })
        default:
            try container.encodeNil()
//            let context = EncodingError.Context(codingPath: container.codingPath, debugDescription: "AnyCodable value cannot be encoded")
//            throw EncodingError.invalidValue(value, context)
        }
    }
}
