import Foundation

class TNAPIServiceProvider {
    func getAuthApiService() -> TNAuthApiService { TNAuthApiService() }
    func getPostApiService() -> TNPostApiService { TNPostApiService() }
    func getTodoApiService() -> TNTodoApiService { TNTodoApiService() }
}
