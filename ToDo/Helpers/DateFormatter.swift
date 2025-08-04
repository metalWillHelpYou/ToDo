//
//  DateFormatter.swift
//  ToDo
//
//  Created by metalWillHelpYou on 04.08.2025.
//

import Foundation

extension DateFormatter {
    static let userDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.timeZone = TimeZone.current
        return formatter
    }()
}
