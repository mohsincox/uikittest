//
//  TNDateWiseCategoriesViewModel.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/06/14.
//

import Foundation
import Combine

final class TNDateWiseCategoriesViewModel: TNViewModel {
    @Published var startDate: Date
    @Published var endDate: Date
    @Published var categories: [TNCategoryResponseBody] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var isDateRangeSheetPresented: Bool = false
    @Published var sheetDraftRangeStart: Date = Date()
    @Published var sheetDraftRangeEnd: Date = Date()
    @Published private(set) var sheetSelectionDayCount: Int = 7
    @Published private(set) var sheetDatePickerToken = UUID()

    private let apiService: TNCategoryApiService

    private let apiDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    init(apiService: TNCategoryApiService = TNCategoryApiService()) {
        self.apiService = apiService
        let today = Date()
        self.endDate = today
        self.startDate = Calendar.current.date(byAdding: .day, value: -6, to: today) ?? today
        super.init()
    }

    var dateRangeDisplayText: String {
        let f = DateFormatter()
        f.dateFormat = "MMM d"
        return "\(f.string(from: startDate)) - \(f.string(from: endDate))"
    }

    func onDateRangeTapped() {
        sheetDraftRangeStart = startDate
        sheetDraftRangeEnd = endDate
        sheetDatePickerToken = UUID()
        isDateRangeSheetPresented = true
    }

    func dismissDateRangeSheetWithoutApplying() {
        isDateRangeSheetPresented = false
    }

    func applySheetDateRange() {
        isDateRangeSheetPresented = false
        startDate = sheetDraftRangeStart
        endDate = sheetDraftRangeEnd
        loadCategories()
    }

    func onPreviousWeekTapped() {
        guard let newStart = Calendar.current.date(byAdding: .day, value: -7, to: startDate),
              let newEnd = Calendar.current.date(byAdding: .day, value: -7, to: endDate) else { return }
        startDate = newStart
        endDate = newEnd
        loadCategories()
    }

    func onNextWeekTapped() {
        let todayStart = Calendar.current.startOfDay(for: Date())
        let endStart = Calendar.current.startOfDay(for: endDate)
        guard endStart < todayStart else { return }
        let shifted = Calendar.current.date(byAdding: .day, value: 7, to: endStart) ?? endStart
        let newEnd = min(shifted, todayStart)
        let newStart = Calendar.current.date(byAdding: .day, value: 7, to: Calendar.current.startOfDay(for: startDate)) ?? startDate
        endDate = newEnd
        startDate = min(newStart, newEnd)
        loadCategories()
    }

    func loadCategories() {
        let start = apiDateFormatter.string(from: startDate)
        let end = apiDateFormatter.string(from: endDate)
        Task {
            await MainActor.run { isLoading = true }
            let result = await apiService.getDateWiseCategories(startDate: start, endDate: end)
            await MainActor.run {
                self.isLoading = false
                switch result {
                case .success(let categories):
                    self.categories = categories
                case .failure(let error):
                    self.errorMessage = error.errorMessage
                }
            }
        }
    }
}
