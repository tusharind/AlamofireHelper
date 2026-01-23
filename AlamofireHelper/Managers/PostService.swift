import Alamofire
import Foundation

struct PostService {
    private let networkManager: NetworkServiceProtocol

    init(networkManager: NetworkServiceProtocol) {
        self.networkManager = networkManager
    }

    func fetchPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        networkManager.request(.allPosts) { result in
            completion(result)
        }
    }

    func createPost(
        title: String,
        body: String,
        completion: @escaping (Result<Post, Error>) -> Void
    ) {
        networkManager.request(.createPost(title: title, body: body, userId: 1))
        { result in
            completion(result)
        }
    }
}
