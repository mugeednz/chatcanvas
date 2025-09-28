//
//  DetailDowlandViewController.swift
//  chatcanvas
//
//  Created by Müge Deniz on 23.04.2025.
//

import UIKit
import SDWebImage
import Photos

class DetailDowlandViewController: UIViewController {
    // MARK: - UI Elements
    private let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        return view
    }()

    private let canvaImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .clear
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 15 // Subtle corner radius
        iv.layer.masksToBounds = true
        iv.layer.shadowColor = UIColor.black.cgColor
        iv.layer.shadowOpacity = 0.4
        iv.layer.shadowRadius = 12
        iv.layer.shadowOffset = CGSize(width: 0, height: 6)
        return iv
    }()
    
    private let backButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "xmark"), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        btn.layer.cornerRadius = 17.5
        btn.layer.masksToBounds = true
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        btn.layer.shadowColor = UIColor.white.cgColor
        btn.layer.shadowOpacity = 0.2
        btn.layer.shadowRadius = 4
        btn.layer.shadowOffset = CGSize.zero
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        gradient.colors = [
            UIColor.white.withAlphaComponent(0.2).cgColor,
            UIColor.white.withAlphaComponent(0.05).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        btn.layer.insertSublayer(gradient, at: 0)
        return btn
    }()
    
    private let downloadButton: UIButton = {
        let btn = UIButton(type: .custom)
        if let image = UIImage(named: "ic_download") {
            btn.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            print("Resim yüklenemedi: ic_download")
        }
        btn.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        btn.layer.cornerRadius = 17.5
        btn.layer.masksToBounds = true
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        btn.layer.shadowColor = UIColor.white.cgColor
        btn.layer.shadowOpacity = 0.2
        btn.layer.shadowRadius = 4
        btn.layer.shadowOffset = CGSize.zero
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        gradient.colors = [
            UIColor.white.withAlphaComponent(0.2).cgColor,
            UIColor.white.withAlphaComponent(0.05).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        btn.layer.insertSublayer(gradient, at: 0)
        btn.imageView?.contentMode = .scaleAspectFit
        return btn
    }()
    
    private let shareButton: UIButton = {
        let btn = UIButton(type: .custom)
        if let image = UIImage(named: "ic_share") {
            btn.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            print("Resim yüklenemedi: ic_share")
        }
        btn.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        btn.layer.cornerRadius = 17.5
        btn.layer.masksToBounds = true
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        btn.layer.shadowColor = UIColor.white.cgColor
        btn.layer.shadowOpacity = 0.2
        btn.layer.shadowRadius = 4
        btn.layer.shadowOffset = CGSize.zero
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        gradient.colors = [
            UIColor.white.withAlphaComponent(0.2).cgColor,
            UIColor.white.withAlphaComponent(0.05).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        btn.layer.insertSublayer(gradient, at: 0)
        btn.imageView?.contentMode = .scaleAspectFit
        return btn
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.cousineBold(ofSize: 22)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.cousineRegular(ofSize: 16)
        label.textColor = .white.withAlphaComponent(0.7)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Perfect for vibrant backgrounds"
        return label
    }()
    
    var selectedArt: Art?
    var selectedCategory: BackgroundCategory?
    private var loadedImage: UIImage?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadImage()
        applyAnimations()
        setupTitle()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        canvaImageView.layer.cornerRadius = 12
        canvaImageView.layer.masksToBounds = true
    }
    
    // MARK: - Setup
    private func setupViews() {
        // Add background image and overlay
        view.addSubview(backgroundImageView)
        view.addSubview(overlayView)
        backgroundImageView.frame = view.bounds
        overlayView.frame = view.bounds
        
        // Add subviews
        view.addSubview(canvaImageView)
        view.addSubview(backButton)
        view.addSubview(downloadButton)
        view.addSubview(shareButton)
        view.addSubview(titleLabel)
        
        canvaImageView.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Back button constraints
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 35),
            backButton.heightAnchor.constraint(equalToConstant: 35),
            
            // Image view constraints
            canvaImageView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 25),
            canvaImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            canvaImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            canvaImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.70),
            
            // Title constraints
            titleLabel.topAnchor.constraint(equalTo: canvaImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Download button constraints (top-right)
            downloadButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            downloadButton.trailingAnchor.constraint(equalTo: shareButton.leadingAnchor, constant: -16),
            downloadButton.widthAnchor.constraint(equalToConstant: 35),
            downloadButton.heightAnchor.constraint(equalToConstant: 35),
            
            // Share button constraints (top-right)
            shareButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            shareButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            shareButton.widthAnchor.constraint(equalToConstant: 35),
            shareButton.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        // Add actions
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        downloadButton.addTarget(self, action: #selector(downloadTapped), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
    }
    
    private func setupTitle() {
        titleLabel.text = selectedCategory?.subtitle ?? "Colorful Gradient"
    }
    
    private func loadImage() {
        guard let art = selectedArt, let url = URL(string: art.image) else {
            canvaImageView.image = UIImage(named: "placeholder")
            backgroundImageView.image = UIImage(named: "placeholder")
            canvaImageView.layer.cornerRadius = 6
            canvaImageView.layer.masksToBounds = true
            return
        }
        
        canvaImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder")) { [weak self] (image, error, cacheType, url) in
            guard let self else { return }
            if let error = error {
                self.canvaImageView.image = UIImage(named: "placeholder")
                self.backgroundImageView.image = UIImage(named: "placeholder")
                self.loadedImage = nil
            } else {
                guard let image = image else { return }
                self.loadedImage = image
                self.backgroundImageView.image = image // Set background to same image
            }
            // Reapply corner radius after image load
            self.canvaImageView.layer.cornerRadius = 6
            self.canvaImageView.layer.masksToBounds = true
        }
    }
    
    private func applyAnimations() {
        // Initial state
        canvaImageView.alpha = 0
        backButton.alpha = 0
        downloadButton.alpha = 0
        shareButton.alpha = 0
        titleLabel.alpha = 0
        subtitleLabel.alpha = 0
        
        // Fade-in and zoom animation for image
        canvaImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9).concatenating(CGAffineTransform(translationX: 0, y: 20))
        UIView.animate(withDuration: 1.0, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut) {
            self.canvaImageView.alpha = 1
            self.canvaImageView.transform = .identity
        }
        
        // Pop animation for back button
        backButton.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.6, delay: 0.4, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseInOut) {
            self.backButton.alpha = 1
            self.backButton.transform = .identity
        }
        
        // Fade-in for title and subtitle
        titleLabel.transform = CGAffineTransform(translationX: 0, y: 20)
        subtitleLabel.transform = CGAffineTransform(translationX: 0, y: 20)
        UIView.animate(withDuration: 0.8, delay: 0.5, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut) {
            self.titleLabel.alpha = 1
            self.subtitleLabel.alpha = 1
            self.titleLabel.transform = .identity
            self.subtitleLabel.transform = .identity
        }
        
        // Pop animation for download and share buttons
        downloadButton.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        shareButton.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.8, delay: 0.6, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseInOut) {
            self.downloadButton.alpha = 1
            self.shareButton.alpha = 1
            self.downloadButton.transform = .identity
            self.shareButton.transform = .identity
        }
    }
    
    // MARK: - Actions
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func downloadTapped() {
        guard let image = loadedImage else {
            showAlert(message: "No image to download.")
            return
        }
        
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            DispatchQueue.main.async {
                switch status {
                case .authorized, .limited:
                    UIImageWriteToSavedPhotosAlbum(image, self, #selector(self?.image(_:didFinishSavingWithError:contextInfo:)), nil)
                case .denied, .restricted:
                    self?.showAlert(message: "Photo library access denied. Please enable access in Settings.")
                case .notDetermined:
                    self?.showAlert(message: "Photo library access not determined.")
                @unknown default:
                    self?.showAlert(message: "Unknown authorization status.")
                }
            }
        }
        
        UIView.animate(withDuration: 0.2) {
            self.downloadButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.downloadButton.transform = .identity
            }
        }
    }
    
    @objc private func shareTapped() {
        guard let image = loadedImage else {
            showAlert(message: "No image to share.")
            return
        }
        
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityController.excludedActivityTypes = [
            .assignToContact,
            .print,
            .addToReadingList
        ]
        
        activityController.popoverPresentationController?.sourceView = shareButton
        activityController.popoverPresentationController?.sourceRect = shareButton.bounds
        
        present(activityController, animated: true) {
        }
        
        UIView.animate(withDuration: 0.2) {
            self.shareButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.shareButton.transform = .identity
            }
        }
    }
    
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            showAlert(message: "Failed to save image: \(error.localizedDescription)")
        } else {
            showAlert(message: "Image saved successfully!")
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
}
