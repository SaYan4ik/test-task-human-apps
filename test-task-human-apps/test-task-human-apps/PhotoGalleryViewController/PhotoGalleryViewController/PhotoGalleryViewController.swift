//
//  PhotoGalleryViewController.swift
//  test-task-human-apps
//
//  Created by Александр Янчик on 21.02.25.
//

import UIKit
import Combine
import PhotosUI


final class PhotoGalleryViewController: UIViewController {
// MARK: - Properties
    private let viewModel: PhotoGalleryViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    private lazy var gestureHandler = GestureHandler(targetView: framedView)
    
// MARK: - UI Elements
    private lazy var framedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.yellow.cgColor
        view.clipsToBounds = false
        return view
    }()
    
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var addPhotoLabel: UILabel = {
        let label = UILabel()
        label.text = "Add new photo \n Tap +"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(
            ofSize: 18,
            weight: .medium
        )
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        button.backgroundColor = Theme.navigationBackground
        button.addTarget(
            self,
            action: #selector(openPhotoGallery),
            for: .touchUpInside
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icons8-disc-64"), for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.addTarget(
            self,
            action: #selector(saveImage),
            for: .touchUpInside
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var filterSwitch: UISwitch = {
        let filterSwitch = UISwitch()
        filterSwitch.isOn = false
        filterSwitch.addTarget(
            self,
            action: #selector(toggleFilter),
            for: .valueChanged
        )
        filterSwitch.translatesAutoresizingMaskIntoConstraints = false
        filterSwitch.isHidden = true
        return filterSwitch
    }()
    
    private lazy var originalLabel: UILabel = {
        let label = UILabel()
        label.text = "Original"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    private lazy var wbLabel: UILabel = {
        let label = UILabel()
        label.text = "W/B"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
// MARK: - Initialization
    init(viewModel: PhotoGalleryViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        setupGestures()
        setupNavigationBar()
    }
    
// MARK: - Setup Views Methods
    private func setupViews() {
        view.backgroundColor = Theme.backgroundPrimary
        view.addSubviews(
            addPhotoLabel,
            addButton,
            activityIndicator,
            filterSwitch,
            originalLabel,
            wbLabel,
            framedView
        )
        view.bringSubviewToFront(activityIndicator)
        framedView.addSubview(photoImageView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            addPhotoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addPhotoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            addButton.widthAnchor.constraint(equalToConstant: 30),
            addButton.heightAnchor.constraint(equalToConstant: 30),
            saveButton.widthAnchor.constraint(equalToConstant: 30),
            saveButton.heightAnchor.constraint(equalToConstant: 30),
            
            originalLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            originalLabel.trailingAnchor.constraint(equalTo: filterSwitch.leadingAnchor, constant: -10),
            originalLabel.centerYAnchor.constraint(equalTo: filterSwitch.centerYAnchor),
            
            filterSwitch.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -26),
            
            wbLabel.leadingAnchor.constraint(equalTo: filterSwitch.trailingAnchor, constant: 10),
            wbLabel.centerYAnchor.constraint(equalTo: filterSwitch.centerYAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func updateFramedViewConstraints(for image: UIImage) {
        NSLayoutConstraint.deactivate(framedView.constraints)
        NSLayoutConstraint.deactivate(photoImageView.constraints)
        
        let imageSize = image.size
        
        guard imageSize.width > 0, imageSize.height > 0 else {
            print("Error: incorrect size")
            return
        }
        
        let aspectRatio = imageSize.width / imageSize.height
        
        NSLayoutConstraint.activate([
            framedView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            framedView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            framedView.widthAnchor.constraint(equalTo: framedView.heightAnchor, multiplier: aspectRatio),
            
            framedView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.8),
            framedView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.6),
            
            framedView.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            framedView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
        ])
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: framedView.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: framedView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: framedView.trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: framedView.bottomAnchor),
        ])
        
        photoImageView.layoutIfNeeded()
        framedView.layoutIfNeeded()
    }
    
    private func setupNavigationBar() {
        setupNavigationBar(title: "Black or white")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
    }
    
    private func setupGestures() {
        gestureHandler.setupGestures()
    }
    
    // MARK: - Bind ViewModel
    private func bindViewModel() {
        viewModel.selectedImagePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.updateUI(for: image)
            }
            .store(in: &cancellables)
        
        viewModel.isBlackAndWhitePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isBlackAndWhite in
                self?.filterSwitch.isOn = isBlackAndWhite
                self?.filterSwitch.isEnabled = true
            }
            .store(in: &cancellables)
    }
    
    // MARK: - UI Update
    private func updateUI(for image: UIImage?) {
        let isImageSelected = image != nil
        
        if let image = image {
            updateFramedViewConstraints(for: image)
            photoImageView.image = image
        }
        
        photoImageView.isHidden = !isImageSelected
        filterSwitch.isHidden = !isImageSelected
        originalLabel.isHidden = !isImageSelected
        wbLabel.isHidden = !isImageSelected
        addPhotoLabel.isHidden = isImageSelected
    }
    
    // MARK: - Actions
    @objc private func openPhotoGallery() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc private func toggleFilter() {
        filterSwitch.isEnabled = false
        self.viewModel.toggleBlackAndWhite()
    }
    
    @objc private func saveImage() {
        guard let image = photoImageView.image else {
            return
        }

        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false

        UIImageWriteToSavedPhotosAlbum(
            image, self,
            #selector(image(_:didFinishSavingWithError:contextInfo:)), nil
        )
    }

    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        view.isUserInteractionEnabled = true

        if let error = error {
            showAlert(
                title: "Error",
                message: "Error during save photo: \(error.localizedDescription)"
            )
        } else {
            showAlert(
                title: "Success",
                message: "Photo was save in gallery."
            )
        }
        
        activityIndicator.stopAnimating()
    }
}

// MARK: - PHPickerViewControllerDelegate
extension PhotoGalleryViewController: PHPickerViewControllerDelegate {
    func picker(
        _ picker: PHPickerViewController,
        didFinishPicking results: [PHPickerResult]
    ) {
        picker.dismiss(animated: true)
        
        guard let result = results.first else { return }
        
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
            if let error = error {
                print("Error load photo: \(error.localizedDescription)")
                return
            }
            
            if let image = image as? UIImage {
                DispatchQueue.main.async {
                    self?.viewModel.setImage(image)
                }
            }
        }
    }
}
