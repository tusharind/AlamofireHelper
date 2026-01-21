import Foundation

enum ImageService {
    /// Fetches a random image from Lorem Picsum and returns a local file URL
    static func fetchRandomImage(completion: @escaping (Result<URL, Error>) -> Void) {
        // Random image every time (UUID avoids caching)
        let url = "https://picsum.photos/600/400?\(UUID().uuidString)"

        NetworkManager.downloadFile(url: url) { result in
            completion(result)
        }
    }
}
