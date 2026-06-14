//
//  TNMultiDatePickerIOS16Calendar.swift
//  LaraApp
//
//  Copyright © 2026 Technonext Software Ltd. All rights reserved.
//

import SwiftUI
import UIKit

@available(iOS 16.0, *)
struct TNMultiDatePickerIOS16Calendar: UIViewRepresentable {

    @Binding var rangeStart: Date
    @Binding var rangeEnd: Date
    let selectionDayCount: Int

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UICalendarView {
        let calendarView = UICalendarView()
        calendarView.calendar = Calendar.current
        calendarView.locale = Locale.autoupdatingCurrent
        calendarView.overrideUserInterfaceStyle = .light
        calendarView.availableDateRange = Self.availableDateInterval()
        calendarView.tintColor = UIColor.systemBlue
        calendarView.fontDesign = .rounded

        let multiSelection = UICalendarSelectionMultiDate(delegate: context.coordinator)
        calendarView.selectionBehavior = multiSelection

        context.coordinator.attach(calendarView: calendarView, selection: multiSelection)
        context.coordinator.applyAlignedRange(containing: rangeEnd, updateBindings: false)

        return calendarView
    }

    func updateUIView(_ calendarView: UICalendarView, context: Context) {
        context.coordinator.parent = self
        context.coordinator.syncSelectionIfNeeded(start: rangeStart, end: rangeEnd)
    }

    private static func availableDateInterval() -> DateInterval {
        TNMultiDatePickerRangeCalculator.calendarAvailableDateInterval()
    }

    final class Coordinator: NSObject, UICalendarSelectionMultiDateDelegate {

        var parent: TNMultiDatePickerIOS16Calendar
        private weak var calendarView: UICalendarView?
        private weak var multiSelection: UICalendarSelectionMultiDate?
        private var appliedApplicableStart: Date?
        private var appliedApplicableEnd: Date?

        init(parent: TNMultiDatePickerIOS16Calendar) {
            self.parent = parent
        }

        func attach(calendarView: UICalendarView, selection: UICalendarSelectionMultiDate) {
            self.calendarView = calendarView
            self.multiSelection = selection
        }

        func syncSelectionIfNeeded(start: Date, end: Date) {
            let cal = Calendar.current
            let startDay = cal.startOfDay(for: start)
            let endDay = cal.startOfDay(for: end)
            guard startDay != appliedApplicableStart || endDay != appliedApplicableEnd else { return }
            applySelection(applicableStart: startDay, applicableEnd: endDay, updateBindings: false, animated: false)
        }

        func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didSelectDate dateComponents: DateComponents) {
            guard let date = Calendar.current.date(from: dateComponents) else { return }
            applyAlignedRange(containing: date, updateBindings: true)
        }

        func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didDeselectDate dateComponents: DateComponents) {
            guard let date = Calendar.current.date(from: dateComponents) else { return }
            applyAlignedRange(containing: date, updateBindings: true)
        }

        func multiDateSelection(_ selection: UICalendarSelectionMultiDate, canDeselectDate dateComponents: DateComponents) -> Bool {
            false
        }

        func multiDateSelection(_ selection: UICalendarSelectionMultiDate, canSelectDate dateComponents: DateComponents) -> Bool {
            guard let date = Calendar.current.date(from: dateComponents) else { return false }
            let today = Calendar.current.startOfDay(for: Date())
            return Calendar.current.startOfDay(for: date) <= today
        }

        func applyAlignedRange(containing date: Date, updateBindings: Bool) {
            let cal = Calendar.current
            let tapped = cal.startOfDay(for: date)
            let applicable = TNMultiDatePickerRangeCalculator.calendarWeekWindow(containing: tapped)
            applySelection(applicableStart: applicable.start, applicableEnd: applicable.end, updateBindings: updateBindings, animated: true)
        }

        private func applySelection(applicableStart: Date, applicableEnd: Date, updateBindings: Bool, animated: Bool) {
            let display = TNMultiDatePickerRangeCalculator.calendarWeekDisplayWindow(containing: applicableEnd)
            setSelectedRange(start: display.start, end: display.end, animated: animated)
            appliedApplicableStart = applicableStart
            appliedApplicableEnd = applicableEnd
            if updateBindings {
                parent.rangeStart = applicableStart
                parent.rangeEnd = applicableEnd
            }
        }

        private func setSelectedRange(start: Date, end: Date, animated: Bool) {
            guard let multiSelection else { return }
            let components = TNMultiDatePickerRangeCalculator.allDates(from: start, to: end).map {
                Calendar.current.dateComponents([.year, .month, .day], from: $0)
            }
            multiSelection.setSelectedDates(components, animated: animated)
            calendarView?.reloadDecorations(forDateComponents: components, animated: animated)
        }
    }
}

@available(iOS 16.0, *)
extension TNMultiDatePickerIOS16Calendar {
    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UICalendarView, context: Context) -> CGSize? {
        let width = proposal.width ?? UIScreen.main.bounds.width
        let height = uiView.sizeThatFits(CGSize(width: width, height: UIView.layoutFittingExpandedSize.height)).height
        return CGSize(width: width, height: max(height, 320))
    }
}
