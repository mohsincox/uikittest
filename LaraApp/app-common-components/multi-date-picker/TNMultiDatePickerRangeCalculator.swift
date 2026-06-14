//
//  TNMultiDatePickerRangeCalculator.swift
//  LaraApp
//
//  Copyright © 2026 Technonext Software Ltd. All rights reserved.
//

import Foundation

enum TNMultiDatePickerRangeCalculator {

    static func startOfWeekSunday(for date: Date, calendar: Calendar = .current) -> Date {
        let day = calendar.startOfDay(for: date)
        let weekday = calendar.component(.weekday, from: day)
        let daysFromSunday = weekday - 1
        return calendar.date(byAdding: .day, value: -daysFromSunday, to: day) ?? day
    }

    static func endOfWeekSaturday(for weekSunday: Date, calendar: Calendar = .current) -> Date {
        let sunday = calendar.startOfDay(for: weekSunday)
        return calendar.date(byAdding: .day, value: 6, to: sunday) ?? sunday
    }

    static func calendarWeekDisplayWindow(containing date: Date, calendar: Calendar = .current) -> (start: Date, end: Date) {
        let day = calendar.startOfDay(for: date)
        let weekStart = startOfWeekSunday(for: day, calendar: calendar)
        let weekSaturday = endOfWeekSaturday(for: weekStart, calendar: calendar)
        return (weekStart, calendar.startOfDay(for: weekSaturday))
    }

    static func calendarWeekWindow(containing date: Date, maxEnd: Date = Date(), calendar: Calendar = .current) -> (start: Date, end: Date) {
        let today = calendar.startOfDay(for: maxEnd)
        let day = calendar.startOfDay(for: min(date, today))
        let display = calendarWeekDisplayWindow(containing: day, calendar: calendar)
        let end = min(display.end, today)
        return (display.start, end)
    }

    static func calendarAvailableDateInterval(maxEnd: Date = Date(), calendar: Calendar = .current) -> DateInterval {
        let today = calendar.startOfDay(for: maxEnd)
        let weekSaturday = endOfWeekSaturday(for: startOfWeekSunday(for: today, calendar: calendar), calendar: calendar)
        let inclusiveEnd = max(today, weekSaturday)
        let exclusiveEnd = calendar.date(byAdding: .day, value: 1, to: inclusiveEnd) ?? inclusiveEnd
        let start = calendar.date(byAdding: .year, value: -10, to: today) ?? today
        return DateInterval(start: start, end: exclusiveEnd)
    }

    static func allDates(from start: Date, to end: Date) -> [Date] {
        let cal = Calendar.current
        var day = cal.startOfDay(for: start)
        let last = cal.startOfDay(for: end)
        guard day <= last else { return [day] }
        var dates: [Date] = []
        while day <= last {
            dates.append(day)
            guard let next = cal.date(byAdding: .day, value: 1, to: day) else { break }
            day = next
        }
        return dates
    }

    static func rangeTitle(from start: Date, to end: Date, calendar: Calendar = .current) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        formatter.setLocalizedDateFormatFromTemplate("MMMd")
        let startText = formatter.string(from: calendar.startOfDay(for: start))
        let endText = formatter.string(from: calendar.startOfDay(for: end))
        return "\(startText) - \(endText)"
    }

    static func alignedWindow(containing date: Date, dayCount: Int = 7, maxEnd: Date = Date(), calendar: Calendar = .current) -> (start: Date, end: Date) {
        _ = dayCount
        return calendarWeekWindow(containing: date, maxEnd: maxEnd, calendar: calendar)
    }
}
