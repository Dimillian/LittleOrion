//
//  Date.swift
//  LittleOrion
//
//  Created by Thomas Ricouard on 09/10/2017.
//  Copyright © 2017 Thomas Ricouard. All rights reserved.
//

import Foundation

extension Date {

    func numberOfDaysSince(date: Date) -> Int {
        let calendar = Calendar.current

        let fromDate = calendar.startOfDay(for: date)
        let toDate = calendar.startOfDay(for: self)

        let components = calendar.dateComponents([.day], from: fromDate, to: toDate)
        return components.day ?? 0
    }
}
