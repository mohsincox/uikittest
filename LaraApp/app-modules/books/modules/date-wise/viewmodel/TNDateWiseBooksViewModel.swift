//
//  TNDateWiseBooksViewModel.swift
//  LaraApp
//
//  Created by TN-LAP-0134 on 15/6/26.
//

import Combine
import Foundation

final class TNDateWiseBooksViewModel: TNViewModel {
    @Published var startDate: Date
    @Published var endDate: Date
    @Published var books: [TNBookResponseBody] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    
    private let apiService: TNBookApiService
    
    private let apiDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    init(apiService: TNBookApiService = TNBookApiService()) {
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
    
    func loadBooks() {
        let start = apiDateFormatter.string(from: startDate)
        let end = apiDateFormatter.string(from: endDate)
        Task {
            await MainActor.run {
                isLoading = true
            }
            let result = await apiService.getDateWiseBooks(startDate: start, endDate: end)
            await MainActor.run {
                self.isLoading = false
                switch result {
                case .success(let books):
                    self.books = books
                case .failure(let error):
                    self.errorMessage = error.errorMessage
                }
            }
        }
    }
    
    func onPreviousWeekTapped() {
        guard let newStart = Calendar.current.date(byAdding: .day, value: -7, to: startDate),
              let newEnd = Calendar.current.date(byAdding: .day, value: -7, to: endDate) else { return }
        startDate = newStart
        endDate = newEnd
        loadBooks()
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
        loadBooks()
    }
}
