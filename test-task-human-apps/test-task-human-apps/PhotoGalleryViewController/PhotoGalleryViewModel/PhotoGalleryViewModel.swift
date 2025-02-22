//
//  PhotoGalleryViewModel.swift
//  test-task-human-apps
//
//  Created by Александр Янчик on 21.02.25.
//

import UIKit
import Combine


// MARK: - Protocols

protocol ImageProcessorProtocol {
    func applyBlackAndWhiteFilter(to image: UIImage) -> UIImage?
}

protocol PhotoGalleryViewModelProtocol {
    var selectedImage: UIImage? { get }
    var selectedImagePublisher: Published<UIImage?>.Publisher { get }
    var isBlackAndWhitePublisher: Published<Bool>.Publisher { get }
    
    func toggleBlackAndWhite()
    func setImage(_ image: UIImage)
}

// MARK: - ImageProcessor

final class ImageProcessor: ImageProcessorProtocol {
    func applyBlackAndWhiteFilter(to image: UIImage) -> UIImage? {
        guard let ciImage = CIImage(image: image) else { return nil }
        
        let filter = CIFilter(name: "CIPhotoEffectMono")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        guard let outputCIImage = filter?.outputImage else { return nil }
        
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
    }
}

// MARK: - PhotoGalleryViewModel

final class PhotoGalleryViewModel: PhotoGalleryViewModelProtocol {
    
    // MARK: - Properties
    @Published private(set) var selectedImage: UIImage?
    @Published private(set) var isBlackAndWhite: Bool = false
    
    var selectedImagePublisher: Published<UIImage?>.Publisher {
        $selectedImage
    }
    var isBlackAndWhitePublisher: Published<Bool>.Publisher {
        $isBlackAndWhite
    }

    private var originalImage: UIImage?
    private let imageProcessor: ImageProcessorProtocol
    
    // MARK: - Initialization
    init(imageProcessor: ImageProcessorProtocol = ImageProcessor()) {
        self.imageProcessor = imageProcessor
    }
    
    // MARK: - Public Methods
    func toggleBlackAndWhite() {
        isBlackAndWhite.toggle()
        updateSelectedImage()
    }
    
    func setImage(_ image: UIImage) {
        originalImage = image
        updateSelectedImage()
    }
    
    // MARK: - Private Methods
    private func updateSelectedImage() {
        guard let originalImage = originalImage else {
            selectedImage = nil
            return
        }
        
        if isBlackAndWhite {
            selectedImage = imageProcessor.applyBlackAndWhiteFilter(to: originalImage)
        } else {
            selectedImage = originalImage
        }
    }
}
