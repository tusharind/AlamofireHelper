import SwiftUI

struct ContentView: View {
    @State private var imageData: Data?
    @State private var isLoading = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if isLoading {
                ProgressView("Loading image...")
                    .foregroundColor(.white)

            } else if let imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
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
                if case let .success(data) = result {
                    imageData = data
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
