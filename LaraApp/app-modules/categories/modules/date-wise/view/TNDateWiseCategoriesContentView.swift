//
//  TNDateWiseCategoriesContentView.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/06/14.
//

import SwiftUI
import UIKit

// MARK: - Main View

struct TNDateWiseCategoriesContentView: View {
    @ObservedObject var viewModel: TNDateWiseCategoriesViewModel

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                TNNavBar(title: "Date Wise Categories",
                         leadingButtonAction: viewModel.onBackTapped,
                         menuButtonAction: viewModel.onMenuTapped)

                dateRangeRow
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)

                Divider()

                if viewModel.isLoading {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.2)
                    Spacer()
                } else if viewModel.categories.isEmpty {
                    Spacer()
                    Text("No categories found")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.categories) { category in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(category.name ?? "")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.primary)
                                    .lineLimit(1)
                                Text(category.remark ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .lineLimit(2)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .background(Color(.systemBackground))
            .onAppear { viewModel.loadCategories() }

            TNDWCBottomSheet(
                isShowing: dateRangeSheetBinding,
                backgroundColor: Color(.systemBackground),
                isOnBackgroundTapEnabled: true,
                isDragToDismissEnabled: true,
                isBottomIgnored: true
            ) {
                TNDWCMultiDatePickerView(
                    draftRangeStart: $viewModel.sheetDraftRangeStart,
                    draftRangeEnd: $viewModel.sheetDraftRangeEnd,
                    selectionDayCount: viewModel.sheetSelectionDayCount,
                    onApply: { viewModel.applySheetDateRange() }
                )
                .id(viewModel.sheetDatePickerToken)
            }
        }
    }

    private var dateRangeSheetBinding: Binding<Bool> {
        Binding(
            get: { viewModel.isDateRangeSheetPresented },
            set: { newValue in
                if !newValue { viewModel.dismissDateRangeSheetWithoutApplying() }
            }
        )
    }

    private var dateRangeRow: some View {
        HStack(spacing: 0) {
            Button {
                viewModel.onPreviousWeekTapped()
            } label: {
                Image(systemName: "chevron.left")
                    .frame(width: 44, height: 44)
                    .foregroundColor(.primary)
            }

            Button {
                viewModel.onDateRangeTapped()
            } label: {
                Text(viewModel.dateRangeDisplayText)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
            }

            Button {
                viewModel.onNextWeekTapped()
            } label: {
                Image(systemName: "chevron.right")
                    .frame(width: 44, height: 44)
                    .foregroundColor(.primary)
            }
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }
}

// MARK: - Bottom Sheet

struct TNDWCBottomSheet<Content: View>: View {
    @Binding var isShowing: Bool
    let content: Content
    let backgroundColor: Color
    let isOnBackgroundTapEnabled: Bool
    let isDragToDismissEnabled: Bool
    let isBottomIgnored: Bool
    let backgroundOpacity: CGFloat
    let topCornerRadius: CGFloat

    @State private var dragOffset: CGFloat = 0
    @GestureState private var isDragGestureActive: Bool = false

    init(
        isShowing: Binding<Bool>,
        backgroundColor: Color = Color(.systemBackground),
        isOnBackgroundTapEnabled: Bool = true,
        isDragToDismissEnabled: Bool = true,
        isBottomIgnored: Bool = true,
        backgroundOpacity: CGFloat = 0.3,
        topCornerRadius: CGFloat = 24,
        @ViewBuilder content: () -> Content
    ) {
        self._isShowing = isShowing
        self.backgroundColor = backgroundColor
        self.isOnBackgroundTapEnabled = isOnBackgroundTapEnabled
        self.isDragToDismissEnabled = isDragToDismissEnabled
        self.isBottomIgnored = isBottomIgnored
        self.backgroundOpacity = backgroundOpacity
        self.topCornerRadius = topCornerRadius
        self.content = content()
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            if isShowing {
                Color.black
                    .opacity(backgroundOpacity)
                    .ignoresSafeArea()
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if isOnBackgroundTapEnabled { isShowing = false }
                    }

                VStack(spacing: 0) {
                    Capsule()
                        .fill(Color(.systemGray3))
                        .frame(width: 36, height: 5)
                        .padding(.top, 8)

                    content
                        .padding(.bottom, isBottomIgnored ? bottomSafeArea : 0)
                }
                .background(backgroundColor)
                .clipShape(TNDWCRoundedCorner(radius: topCornerRadius, corners: [.topLeft, .topRight]))
                .shadow(color: Color.black.opacity(0.16), radius: 8, x: 0, y: -3)
                .offset(y: dragOffset)
                .transition(.move(edge: .bottom))
                .zIndex(1)
                .gesture(isDragToDismissEnabled ? dragGesture : nil)
                .onChange(of: isDragGestureActive) { isActive in
                    if !isActive {
                        withAnimation(.easeInOut(duration: 0.1)) { dragOffset = 0 }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
    }

    private var bottomSafeArea: CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .safeAreaInsets.bottom ?? 0
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .updating($isDragGestureActive) { _, state, _ in state = true }
            .onChanged { value in
                guard value.translation.height > 0 else { return }
                dragOffset = value.translation.height
            }
            .onEnded { value in
                let crossedDrag = value.translation.height > 50
                let crossedSpeed = value.predictedEndLocation.y > value.startLocation.y + 200
                if crossedDrag || crossedSpeed {
                    withAnimation(.easeInOut(duration: 0.1)) { isShowing = false }
                }
                withAnimation(.easeInOut(duration: 0.3)) { dragOffset = 0 }
            }
    }
}

private struct TNDWCRoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// MARK: - Multi Date Picker

struct TNDWCMultiDatePickerView: View {
    @Binding var draftRangeStart: Date
    @Binding var draftRangeEnd: Date
    let selectionDayCount: Int
    let onApply: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Text("Select Date Range")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .center)

            calendarContent
                .frame(maxWidth: .infinity)

            legacyRangePreview

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
    private var legacyRangePreview: some View {
        if #unavailable(iOS 16.0) {
            HStack(spacing: 8) {
                Image(systemName: "calendar")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.blue)
                Text(TNDWCRangeCalculator.rangeTitle(from: draftRangeStart, to: draftRangeEnd))
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.blue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(Color.blue.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }

    @ViewBuilder
    private var calendarContent: some View {
        if #available(iOS 16.0, *) {
            TNDWCCalendarIOS16(
                rangeStart: $draftRangeStart,
                rangeEnd: $draftRangeEnd,
                selectionDayCount: selectionDayCount
            )
        } else {
            DatePicker("", selection: $draftRangeEnd, in: ...Date(), displayedComponents: .date)
                .datePickerStyle(.graphical)
                .labelsHidden()
                .tint(.blue)
                .fixedSize(horizontal: false, vertical: true)
                .onAppear { syncLegacy(endingOn: draftRangeEnd) }
                .onChange(of: draftRangeEnd) { syncLegacy(endingOn: $0) }
        }
    }

    private func syncLegacy(endingOn date: Date) {
        let window = TNDWCRangeCalculator.alignedWindow(containing: date, dayCount: selectionDayCount)
        let cal = Calendar.current
        draftRangeStart = cal.startOfDay(for: window.start)
        draftRangeEnd   = cal.startOfDay(for: window.end)
    }
}

// MARK: - iOS 16 Calendar

@available(iOS 16.0, *)
struct TNDWCCalendarIOS16: UIViewRepresentable {
    @Binding var rangeStart: Date
    @Binding var rangeEnd: Date
    let selectionDayCount: Int

    func makeCoordinator() -> Coordinator { Coordinator(parent: self) }

    func makeUIView(context: Context) -> UICalendarView {
        let cv = UICalendarView()
        cv.calendar = .current
        cv.locale = .autoupdatingCurrent
        cv.overrideUserInterfaceStyle = .light
        cv.availableDateRange = TNDWCRangeCalculator.calendarAvailableDateInterval()
        cv.tintColor = .systemBlue
        cv.fontDesign = .rounded
        let sel = UICalendarSelectionMultiDate(delegate: context.coordinator)
        cv.selectionBehavior = sel
        context.coordinator.attach(calendarView: cv, selection: sel)
        context.coordinator.applyAlignedRange(containing: rangeEnd, updateBindings: false)
        return cv
    }

    func updateUIView(_ cv: UICalendarView, context: Context) {
        context.coordinator.parent = self
        context.coordinator.syncSelectionIfNeeded(start: rangeStart, end: rangeEnd)
    }

    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UICalendarView, context: Context) -> CGSize? {
        let width = proposal.width ?? UIScreen.main.bounds.width
        let height = uiView.sizeThatFits(CGSize(width: width, height: UIView.layoutFittingExpandedSize.height)).height
        return CGSize(width: width, height: max(height, 320))
    }

    final class Coordinator: NSObject, UICalendarSelectionMultiDateDelegate {
        var parent: TNDWCCalendarIOS16
        private weak var calendarView: UICalendarView?
        private weak var multiSelection: UICalendarSelectionMultiDate?
        private var appliedStart: Date?
        private var appliedEnd: Date?

        init(parent: TNDWCCalendarIOS16) { self.parent = parent }

        func attach(calendarView: UICalendarView, selection: UICalendarSelectionMultiDate) {
            self.calendarView = calendarView
            self.multiSelection = selection
        }

        func syncSelectionIfNeeded(start: Date, end: Date) {
            let cal = Calendar.current
            let s = cal.startOfDay(for: start), e = cal.startOfDay(for: end)
            guard s != appliedStart || e != appliedEnd else { return }
            applySelection(applicableStart: s, applicableEnd: e, updateBindings: false, animated: false)
        }

        func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didSelectDate dc: DateComponents) {
            guard let d = Calendar.current.date(from: dc) else { return }
            applyAlignedRange(containing: d, updateBindings: true)
        }

        func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didDeselectDate dc: DateComponents) {
            guard let d = Calendar.current.date(from: dc) else { return }
            applyAlignedRange(containing: d, updateBindings: true)
        }

        func multiDateSelection(_ selection: UICalendarSelectionMultiDate, canDeselectDate dc: DateComponents) -> Bool { false }

        func multiDateSelection(_ selection: UICalendarSelectionMultiDate, canSelectDate dc: DateComponents) -> Bool {
            guard let d = Calendar.current.date(from: dc) else { return false }
            return Calendar.current.startOfDay(for: d) <= Calendar.current.startOfDay(for: Date())
        }

        func applyAlignedRange(containing date: Date, updateBindings: Bool) {
            let tapped = Calendar.current.startOfDay(for: date)
            let w = TNDWCRangeCalculator.calendarWeekWindow(containing: tapped)
            applySelection(applicableStart: w.start, applicableEnd: w.end, updateBindings: updateBindings, animated: true)
        }

        private func applySelection(applicableStart: Date, applicableEnd: Date, updateBindings: Bool, animated: Bool) {
            let display = TNDWCRangeCalculator.calendarWeekDisplayWindow(containing: applicableEnd)
            let components = TNDWCRangeCalculator.allDates(from: display.start, to: display.end)
                .map { Calendar.current.dateComponents([.year, .month, .day], from: $0) }
            multiSelection?.setSelectedDates(components, animated: animated)
            calendarView?.reloadDecorations(forDateComponents: components, animated: animated)
            appliedStart = applicableStart
            appliedEnd   = applicableEnd
            if updateBindings {
                parent.rangeStart = applicableStart
                parent.rangeEnd   = applicableEnd
            }
        }
    }
}

// MARK: - Range Calculator

enum TNDWCRangeCalculator {

    static func startOfWeekSunday(for date: Date, calendar: Calendar = .current) -> Date {
        let day = calendar.startOfDay(for: date)
        let daysFromSunday = calendar.component(.weekday, from: day) - 1
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
        let day   = calendar.startOfDay(for: min(date, today))
        let display = calendarWeekDisplayWindow(containing: day, calendar: calendar)
        return (display.start, min(display.end, today))
    }

    static func calendarAvailableDateInterval(maxEnd: Date = Date(), calendar: Calendar = .current) -> DateInterval {
        let today = calendar.startOfDay(for: maxEnd)
        let sat   = endOfWeekSaturday(for: startOfWeekSunday(for: today, calendar: calendar), calendar: calendar)
        let inclusiveEnd  = max(today, sat)
        let exclusiveEnd  = calendar.date(byAdding: .day, value: 1, to: inclusiveEnd) ?? inclusiveEnd
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
        let f = DateFormatter()
        f.locale = .autoupdatingCurrent
        f.setLocalizedDateFormatFromTemplate("MMMd")
        return "\(f.string(from: calendar.startOfDay(for: start))) - \(f.string(from: calendar.startOfDay(for: end)))"
    }

    static func alignedWindow(containing date: Date, dayCount: Int = 7, maxEnd: Date = Date(), calendar: Calendar = .current) -> (start: Date, end: Date) {
        _ = dayCount
        return calendarWeekWindow(containing: date, maxEnd: maxEnd, calendar: calendar)
    }
}
