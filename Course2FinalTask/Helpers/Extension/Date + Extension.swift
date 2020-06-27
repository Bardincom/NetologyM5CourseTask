//
//  Date + Extension.swift
//  Course2FinalTask
//
//  Created by Aleksey Bardin on 04.03.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import Foundation

extension Date {
    /// Форматирует дату в String в формате Месяц Число Год Часы
    func displayDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        dateFormatter.doesRelativeDateFormatting = true
        return dateFormatter.string(from: self)
    }
}
