//
//  SwiftUIView.swift
//  Presentation
//
//  Created by 홍기웅 on 2/25/25.
//

import SwiftUI
import Shared
struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    @StateObject private var viewModel: ImageLoaderViewModel
    private let content: (Image) -> Content
    private let placeholder: () -> Placeholder
    
    init(url: URL, @ViewBuilder content: @escaping (Image) -> Content, @ViewBuilder placeholder: @escaping () -> Placeholder) {
        self._viewModel = StateObject(wrappedValue: ImageLoaderViewModel(url: url))
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        Group {
            if let data = viewModel.imageData, let uiImage = UIImage(data: data) {
                content(Image(uiImage: uiImage))
            } else if viewModel.isLoading {
                ProgressView()
            } else {
                placeholder()
            }
        }
    }
}

private final class ImageLoaderViewModel: ObservableObject {
    @Published var imageData: Data?
    @Published var isLoading: Bool = false
    
    private let url: URL
    
    init(url: URL) {
        self.url = url
        loadImage()
    }
    
    func loadImage() {
        Task {
            await fetchImage()
        }
    }
    
    private func fetchImage() async {
        await updateIsLoading(true)
        
        let etag = ImageCache.etag(forKey: url.absoluteString)
        let result = await ImageLoader.download(from: url, etag: etag)
        
        await updateIsLoading(false)
        
        switch result {
        case .success(let data, let newEtag):
            ImageCache.store(data, etag: newEtag, forKey: self.url.absoluteString)
            await updateImageData(data)
            
        case .notModified:
            if let cachedData = await ImageCache.fetch(forKey: self.url.absoluteString) {
                await updateImageData(cachedData)
            }
        case .failure:
            await updateImageData(nil)
        }
    }
    
    @MainActor private func updateImageData(_ imageData: Data?) {
        self.imageData = imageData
    }
    
    @MainActor private func updateIsLoading(_ isLoading: Bool) {
        self.isLoading = isLoading
    }
}

