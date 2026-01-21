import Foundation

enum ImageService {
    /// Fetches a random image from Lorem Picsum as Data
    static func fetchRandomImage(completion: @escaping (Result<Data, Error>) -> Void) {

        let url = "https://picsum.photos/600/400?\(UUID().uuidString)"

        RequestBuilder.get(url: url)
            .executeData { result in
                completion(result)
            }
    }
}
