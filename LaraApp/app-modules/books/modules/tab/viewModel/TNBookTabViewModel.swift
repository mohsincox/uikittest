//
//  TNBookTabViewModel.swift
//  LaraApp
//
//  Created by TN-LAP-0134 on 10/6/26.
//

import Combine

final class TNBookTabViewModel: TNViewModel {
    @Published var books: [TNBookResponseBody] = []
    @Published var chapters: [TNChapterResponseBody] = []
    @Published var selectedBookIndex: Int = 0
    @Published var isLoading: Bool = false
    @Published var isLoadingChapters: Bool = false
    @Published var errorMessage: String = ""
    
    private let bookApiService: TNBookApiService
    private let chapterApiService: TNChapterApiService
    
    init(bookApiService: TNBookApiService = TNBookApiService(),
         chapterApiService: TNChapterApiService = TNChapterApiService()) {
        self.bookApiService = bookApiService
        self.chapterApiService = chapterApiService
        super.init()
        bindLifeCycle()
    }
    
    private func bindLifeCycle() {
        lifeCycle.didAppearSubject
            .sink { [weak self] _ in Task { await self?.loadBooks() }}
            .store(in: &cancellables)
    }
    
    private func loadBooks() async {
        await MainActor.run {
            isLoading = true
            errorMessage = ""
        }
        let result = await bookApiService.getBooks()
        await MainActor.run {
            self.isLoading = false
            switch result {
            case .success(let books):
                self.books = books
                if !books.isEmpty {
                    self.selectedBookIndex = 0
                    Task {
                        await self.loadChaptersForSelectedBook()
                    }
                }
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func selectBook(at index: Int) {
            guard index >= 0 && index < books.count else { return }
            selectedBookIndex = index
            Task {
                await loadChaptersForSelectedBook()
            }
        }
    
    private func loadChaptersForSelectedBook() async {
        guard selectedBookIndex < books.count,
              let categoryId = books[selectedBookIndex].id else { return }
        
        await MainActor.run {
            isLoadingChapters = true
        }
        
        let result = await chapterApiService.getChapters(bookId: categoryId)
        
        await MainActor.run {
            self.isLoadingChapters = false
            switch result {
            case .success(let products):
                self.chapters = products
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
