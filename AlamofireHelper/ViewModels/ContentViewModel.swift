import Combine
import Foundation
import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading = false

    private let postService: PostService

    init(postService: PostService) {
        self.postService = postService
    }

    func loadPosts() {
        isLoading = true

        postService.fetchPosts { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let fetchedPosts):
                    self?.posts = fetchedPosts
                case .failure(let error):
                    print("Error fetching posts: \(error.localizedDescription)")
                }
            }
        }
    }

    func createPost() {
        isLoading = true

        postService.createPost(
            title: "New Post",
            body: "This is a new post created via AlamofireHelper!"
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let newPost):

                    self?.posts.insert(newPost, at: 0)
                case .failure(let error):
                    print("Error creating post: \(error.localizedDescription)")
                }
            }
        }
    }
}
