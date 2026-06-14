//
//  TNMultiDatePickerView.swift
//  LaraApp
//
//  Copyright © 2026 Technonext Software Ltd. All rights reserved.
//

import SwiftUI

struct TNMultiDatePickerView: View {

    @Binding var draftRangeStart: Date
    @Binding var draftRangeEnd: Date
    let selectionDayCount: Int
    let title: String
    let onApply: () -> Void

    init(
        draftRangeStart: Binding<Date>,
        draftRangeEnd: Binding<Date>,
        selectionDayCount: Int,
        title: String = "Select Date Range",
        onApply: @escaping () -> Void
    ) {
        self._draftRangeStart = draftRangeStart
        self._draftRangeEnd = draftRangeEnd
        self.selectionDayCount = max(selectionDayCount, 1)
        self.title = title
        self.onApply = onApply
    }

    var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)

            calendarContent
                .frame(maxWidth: .infinity)

            legacySelectedRangePreview

            Button(action: onApply) {
                Text("Apply")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 4)
        }
        .padding(.horizontal, 16)
        .padding(.top, 4)
        .padding(.bottom, 16)
        .fixedSize(horizontal: false, vertical: true)
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .preferredColorScheme(.light)
        .environment(\.colorScheme, .light)
    }

    @ViewBuilder
    private var legacySelectedRangePreview: some View {
        if #unavailable(iOS 16.0) {
            HStack(spacing: 8) {
                Image(systemName: "calendar")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.blue)
                Text(TNMultiDatePickerRangeCalculator.rangeTitle(from: draftRangeStart, to: draftRangeEnd))
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.blue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .background(Color.blue.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }

    @ViewBuilder
    private var calendarContent: some View {
        if #available(iOS 16.0, *) {
            TNMultiDatePickerIOS16Calendar(
                rangeStart: $draftRangeStart,
                rangeEnd: $draftRangeEnd,
                selectionDayCount: selectionDayCount
            )
        } else {
            DatePicker(
                "",
                selection: $draftRangeEnd,
                in: ...Date(),
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .labelsHidden()
            .tint(.blue)
            .fixedSize(horizontal: false, vertical: true)
            .onAppear { syncLegacyPickerToAlignedRange(endingOn: draftRangeEnd) }
            .onChange(of: draftRangeEnd) { tappedEnd in
                syncLegacyPickerToAlignedRange(endingOn: tappedEnd)
            }
        }
    }

    private func syncLegacyPickerToAlignedRange(endingOn date: Date) {
        let window = TNMultiDatePickerRangeCalculator.alignedWindow(containing: date, dayCount: selectionDayCount)
        let cal = Calendar.current
        draftRangeStart = cal.startOfDay(for: window.start)
        draftRangeEnd = cal.startOfDay(for: window.end)
    }
}
