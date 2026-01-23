import Combine
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: ContentViewModel

    init() {
        let networkManager = NetworkManager()
        let postService = PostService(networkManager: networkManager)
        _viewModel = StateObject(
            wrappedValue: ContentViewModel(postService: postService)
        )
    }

    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoading && viewModel.posts.isEmpty {
                    ProgressView("Loading posts...")
                } else {
                    List(viewModel.posts) { post in
                        VStack(alignment: .leading, spacing: 5) {
                            Text(post.title)
                                .font(.headline)
                            Text(post.body)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Posts")
            .toolbar {
                Button(action: {
                    viewModel.createPost()
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .onAppear {
            viewModel.loadPosts()
        }
    }
}

#Preview {
    ContentView()
}
