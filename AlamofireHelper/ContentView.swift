import SwiftUI

struct ContentView: View {

    @State private var imageURL: URL?
    @State private var isLoading = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if isLoading {
                ProgressView("Loading image...")
                    .foregroundColor(.white)

            } else if let imageURL {
                Image(uiImage: UIImage(contentsOfFile: imageURL.path)!)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(20)
                    .padding()

            } else {
                Text("Tap to load an image 🖼️")
                    .foregroundColor(.white)
            }
        }
        .onTapGesture {
            loadImage()
        }
        .onAppear {
            loadImage()
        }
    }

    private func loadImage() {
        isLoading = true

        ImageService.fetchRandomImage { result in
            DispatchQueue.main.async {
                isLoading = false
                if case .success(let url) = result {
                    imageURL = url
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

