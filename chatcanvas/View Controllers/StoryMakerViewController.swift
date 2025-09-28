//
//  StoryMakerViewController.swift
//  chatcanvas
//
//  Created by Müge Deniz on 27.04.2025.
//

import UIKit
import PhotosUI
import AVFoundation

class StoryMakerViewController: UIViewController, EditViewControllerDelegate, StickerViewControllerDelegate, RotateViewControllerDelegate, FilterViewControllerDelegate, TextViewControllerDelegate, MusicViewControllerDelegate {
    // MARK: - Delegates
    func didSelectMusic(image: UIImage?, title: String, url: URL) {
        selectedImage = image
        imageView.image = image
        selectedMusicTitle = title
        selectedMusicURL = url
        playSelectedMusic()
        musicPlayPauseButton.isHidden = false
    }
    
    func didFinishAddingText(image: UIImage) {
        imageView.image = image
    }
    
    func didFinishFiltering(image: UIImage?) {
        imageView.image = image
    }
    
    func didFinishRotating(image: UIImage) {
        imageView.image = image
    }
    
    func didFinishAddingStickers(image: UIImage) {
        imageView.image = image
    }
    
    func didFinishEditing(image: UIImage?) {
        selectedImage = image
        imageView.image = image
        imageView.isHidden = false
        emptyView.isHidden = true
        warningLabel.isHidden = true
        downloadButton.isHidden = false
        deleteButton.isHidden = false
    }
    
    // MARK: - Properties
    private var selectedImage: UIImage?
    private var selectedMusicTitle: String?
    private var selectedMusicURL: URL?
    private var musicPlayer: AVAudioPlayer?
    var onDismiss: (() -> Void)?  

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create Story"
        label.font = UIFont(name: "Cousine-Bold", size: 34) ?? .boldSystemFont(ofSize: 34)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 0.18
        label.layer.shadowRadius = 4
        label.layer.shadowOffset = CGSize(width: 0, height: 2)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Select an image to start editing"
        label.font = UIFont(name: "Cousine-Regular", size: 16) ?? .systemFont(ofSize: 16)
        label.textColor = UIColor(white: 1, alpha: 0.5)
        label.textAlignment = .center
        return label
    }()
    
    private let closeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "xmark"), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor(white: 1, alpha: 0.15)
        btn.layer.cornerRadius = 17.5
        return btn
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 32
        iv.isHidden = true
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(white: 1, alpha: 0.10).cgColor, UIColor(white: 1, alpha: 0.04).cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.cornerRadius = 32
        iv.backgroundColor = UIColor(white: 1, alpha: 0.08)
        iv.layer.insertSublayer(gradient, at: 0)
        iv.layer.shadowColor = UIColor.black.cgColor
        iv.layer.shadowOpacity = 0.10
        iv.layer.shadowRadius = 16
        iv.layer.shadowOffset = CGSize(width: 0, height: 8)
        return iv
    }()
    
    private let emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.08)
        view.layer.cornerRadius = 32
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(white: 1, alpha: 0.10).cgColor, UIColor(white: 1, alpha: 0.04).cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.cornerRadius = 32
        view.layer.insertSublayer(gradient, at: 0)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.10
        view.layer.shadowRadius = 16
        view.layer.shadowOffset = CGSize(width: 0, height: 8)
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo.stack")
        imageView.tintColor = UIColor(red: 0.2, green: 0.85, blue: 0.5, alpha: 1.0)
        imageView.contentMode = .scaleAspectFit
        
        let titleLabel = UILabel()
        titleLabel.text = "Tap to select an image"
        titleLabel.textColor = UIColor(white: 1, alpha: 0.8)
        titleLabel.font = UIFont(name: "Cousine-Regular", size: 16) ?? .systemFont(ofSize: 16)
        titleLabel.textAlignment = .center
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = "or drag and drop"
        subtitleLabel.textColor = UIColor(white: 1, alpha: 0.4)
        subtitleLabel.font = UIFont(name: "Cousine-Regular", size: 14) ?? .systemFont(ofSize: 14)
        subtitleLabel.textAlignment = .center
        
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 65, height: 70)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
        blur.layer.cornerRadius = 22
        blur.clipsToBounds = true
        blur.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundView = blur
        cv.backgroundColor = UIColor(white: 0.08, alpha: 0.7)
        cv.showsHorizontalScrollIndicator = false
        cv.alwaysBounceHorizontal = true
        return cv
    }()
    
    private let warningLabel: UILabel = {
        let label = UILabel()
        label.text = "Please select an image to start editing"
        label.font = .systemFont(ofSize: 14) // Note: .cousineRegular(ofSize:) is not a standard method; replaced with system font
        label.textColor = UIColor(white: 1, alpha: 0.6)
        label.textAlignment = .center
        return label
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
        btn.isHidden = true
        return btn
    }()
    
    private let deleteButton: UIButton = {
        let btn = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        btn.setImage(UIImage(systemName: "xmark.circle.fill", withConfiguration: config), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor(white: 0, alpha: 0.5)
        btn.layer.cornerRadius = 15
        btn.isHidden = true
        return btn
    }()
    
    private let musicPlayPauseButton: UIButton = {
        let btn = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        btn.setImage(UIImage(systemName: "play.circle.fill", withConfiguration: config), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor(white: 0, alpha: 0.5)
        btn.layer.cornerRadius = 15
        btn.isHidden = true
        return btn
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        
        // Setup AVAudioSession for audio playback
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up AVAudioSession: \(error)")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        musicPlayer?.stop()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.06, green: 0.07, blue: 0.08, alpha: 1.0)
        
        // Add close button
        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 35),
            closeButton.heightAnchor.constraint(equalToConstant: 35)
        ])
        closeButton.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        
        // Add download button
        view.addSubview(downloadButton)
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            downloadButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            downloadButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            downloadButton.widthAnchor.constraint(equalToConstant: 35),
            downloadButton.heightAnchor.constraint(equalToConstant: 35)
        ])
        downloadButton.addTarget(self, action: #selector(handleDownload), for: .touchUpInside)
        
        // Add music play/pause button
        view.addSubview(musicPlayPauseButton)
        musicPlayPauseButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            musicPlayPauseButton.widthAnchor.constraint(equalToConstant: 30),
            musicPlayPauseButton.heightAnchor.constraint(equalToConstant: 30),
            musicPlayPauseButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            musicPlayPauseButton.leadingAnchor.constraint(equalTo: downloadButton.trailingAnchor, constant: 8)
        ])
        musicPlayPauseButton.addTarget(self, action: #selector(toggleMusicPlayback), for: .touchUpInside)
        
        // Add title labels
        let titleStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        titleStack.axis = .vertical
        titleStack.spacing = 8
        titleStack.alignment = .center
        
        view.addSubview(titleStack)
        titleStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            titleStack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Add imageView directly to main view
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: titleStack.bottomAnchor, constant: 40),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
        
        // Add emptyView (for when no image is selected)
        view.addSubview(emptyView)
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: titleStack.bottomAnchor, constant: 40),
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emptyView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
        
        // Add deleteButton to main view (overlay on imageView)
        view.addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteButton.widthAnchor.constraint(equalToConstant: 30),
            deleteButton.heightAnchor.constraint(equalToConstant: 30),
            deleteButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 12),
            deleteButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -12)
        ])
        deleteButton.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
        
        // Add warning label and collection view
        view.addSubview(warningLabel)
        view.addSubview(collectionView)
        
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            warningLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            warningLabel.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -20),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            collectionView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        // Add tap gesture to empty view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleImageSelection))
        emptyView.addGestureRecognizer(tapGesture)
        emptyView.isUserInteractionEnabled = true
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ToolCell.self, forCellWithReuseIdentifier: "ToolCell")
    }
    
    // MARK: - Music Playback
    private func playSelectedMusic() {
        guard let url = selectedMusicURL else {
            print("No music URL to play")
            return
        }
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: url)
            musicPlayer?.play()
            musicPlayPauseButton.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        } catch {
            print("Failed to play music in StoryMaker: \(error)")
        }
    }
    
    @objc private func toggleMusicPlayback() {
        guard let player = musicPlayer else { return }
        
        if player.isPlaying {
            player.pause()
            musicPlayPauseButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        } else {
            player.play()
            musicPlayPauseButton.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        }
    }
    
    // MARK: - Actions
    @objc private func handleClose() {
        musicPlayer?.stop()
        dismiss(animated: true)
    }
    
    @objc private func handleImageSelection() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc private func handleDownload() {
        guard let image = selectedImage else {
            print("No image to download")
            return
        }
        
        // Save the image to the photo library
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
        // Optionally, save the music URL or title if needed
        if let musicTitle = selectedMusicTitle, let musicURL = selectedMusicURL {
        }
    }
    
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Error saving image: \(error)")
        } else {
            print("Image saved successfully")
            // Başarılıysa alert göster
            let alert = UIAlertController(title: "Saved!", message: "Image saved successfully.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
        }
    }
    
    @objc private func handleDelete() {
        let alert = UIAlertController(
            title: "Delete Image",
            message: "Are you sure you want to delete this image?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.deleteImage()
        })
        
        present(alert, animated: true)
    }
    
    private func deleteImage() {
        selectedImage = nil
        imageView.image = nil
        imageView.isHidden = true
        emptyView.isHidden = false
        deleteButton.isHidden = true
        downloadButton.isHidden = true
        musicPlayPauseButton.isHidden = true
        warningLabel.isHidden = false
        selectedMusicURL = nil
        selectedMusicTitle = nil
        musicPlayer?.stop()
        musicPlayer = nil
    }
}

// MARK: - PHPickerViewControllerDelegate
extension StoryMakerViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let result = results.first else { return }
        
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            guard let image = object as? UIImage else { return }
            
            DispatchQueue.main.async {
                self?.selectedImage = image
                self?.imageView.image = image
                self?.imageView.isHidden = false
                self?.emptyView.isHidden = true
                self?.warningLabel.isHidden = true
                self?.downloadButton.isHidden = false
                self?.deleteButton.isHidden = false
            }
        }
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension StoryMakerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ToolCell", for: indexPath) as! ToolCell
        
        let tools: [(title: String, color: UIColor)] = [
            ("Crop", UIColor(red: 0.2, green: 0.5, blue: 1.0, alpha: 1.0)),
            ("Filter", UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0)),
            ("Music", UIColor(red: 0.6, green: 0.3, blue: 0.9, alpha: 1.0)),
            ("Text", UIColor(red: 1.0, green: 0.6, blue: 0.0, alpha: 1.0)),
            ("Sticker", UIColor(red: 0.2, green: 0.8, blue: 0.8, alpha: 1.0)),
            ("Rotate", UIColor(red: 0.9, green: 0.3, blue: 0.6, alpha: 1.0))
        ]
        
        let tool = tools[indexPath.item]
        cell.configure(with: tool.title, color: tool.color)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedImage == nil {
            warningLabel.isHidden = false
            // Add a subtle animation to the warning label
            UIView.animate(withDuration: 0.3) {
                self.warningLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            } completion: { _ in
                UIView.animate(withDuration: 0.2) {
                    self.warningLabel.transform = .identity
                }
            }
            return
        }
        
        // Handle tool selection here with haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        // Pause any playing music before navigating to another tool
        musicPlayer?.pause()
        musicPlayPauseButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        
        switch indexPath.item {
        case 0:
            if let selectedImage = selectedImage {
                let cropVC = CropViewController(image: selectedImage)
                cropVC.delegate = self
                cropVC.modalPresentationStyle = .fullScreen
                present(cropVC, animated: true)
            }
        case 1:
            if let selectedImage = selectedImage {
                let filterVC = FilterViewController(image: selectedImage)
                filterVC.delegate = self
                filterVC.modalPresentationStyle = .fullScreen
                present(filterVC, animated: true)
            }
        case 2:
            if let selectedImage = selectedImage {
                let musicVC = MusicViewController(image: selectedImage)
                musicVC.delegate = self
                musicVC.modalPresentationStyle = .fullScreen
                present(musicVC, animated: true)
            }
        case 3:
            if let selectedImage = selectedImage {
                let textVC = TextViewController(image: selectedImage)
                textVC.delegate = self
                textVC.modalPresentationStyle = .fullScreen
                present(textVC, animated: true)
            }
        case 4:
            if let selectedImage = selectedImage {
                let stickerVC = StickerViewController(image: selectedImage)
                stickerVC.delegate = self
                stickerVC.modalPresentationStyle = .fullScreen
                present(stickerVC, animated: true)
            }
        case 5:
            if let selectedImage = selectedImage {
                let rotateVC = RotateViewController(image: selectedImage)
                rotateVC.delegate = self
                rotateVC.modalPresentationStyle = .fullScreen
                present(rotateVC, animated: true)
            }
        default:
            break
        }
    }
}

class ToolCell: UICollectionViewCell {
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14
        view.clipsToBounds = true
        view.backgroundColor = .clear
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .white
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Cousine-Regular", size: 10) ?? .systemFont(ofSize: 10)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private var gradientBorder: CAGradientLayer?
    private var borderMask: CAShapeLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(containerView)
        let stackView = UIStackView(arrangedSubviews: [iconImageView, titleLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center
        containerView.addSubview(stackView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func configure(with title: String, color: UIColor) {
        titleLabel.text = title
        containerView.backgroundColor = .clear
        switch title {
        case "Crop":
            iconImageView.image = UIImage(systemName: "crop")
        case "Filter":
            iconImageView.image = UIImage(systemName: "camera.filters")
        case "Music":
            iconImageView.image = UIImage(systemName: "music.note")
        case "Text":
            iconImageView.image = UIImage(systemName: "textformat")
        case "Sticker":
            iconImageView.image = UIImage(systemName: "face.smiling")
        case "Rotate":
            iconImageView.image = UIImage(systemName: "rotate.right")
        default:
            break
        }
        gradientBorder?.removeFromSuperlayer()
        borderMask = nil
        if isSelected {
            let gradient = CAGradientLayer()
            gradient.frame = containerView.bounds
            gradient.colors = [UIColor.systemPurple.cgColor, UIColor.systemPink.cgColor, UIColor.systemYellow.cgColor]
            gradient.startPoint = CGPoint(x: 0, y: 0)
            gradient.endPoint = CGPoint(x: 1, y: 1)
            let shape = CAShapeLayer()
            shape.path = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: 14).cgPath
            shape.lineWidth = 3
            shape.fillColor = UIColor.clear.cgColor
            shape.strokeColor = UIColor.white.cgColor
            gradient.mask = shape
            containerView.layer.addSublayer(gradient)
            gradientBorder = gradient
            borderMask = shape
            containerView.layer.shadowColor = UIColor.systemPink.cgColor
            containerView.layer.shadowOpacity = 0.5
            containerView.layer.shadowRadius = 12
            containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
            UIView.animate(withDuration: 0.18, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
                self.containerView.transform = CGAffineTransform(scaleX: 1.10, y: 1.10)
            }, completion: { _ in
                self.containerView.transform = .identity
            })
        } else {
            containerView.layer.shadowOpacity = 0.0
            containerView.layer.shadowRadius = 0
            containerView.layer.shadowColor = UIColor.clear.cgColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientBorder?.frame = containerView.bounds
        borderMask?.path = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: 14).cgPath
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        titleLabel.text = nil
        containerView.backgroundColor = .clear
        gradientBorder?.removeFromSuperlayer()
        containerView.layer.shadowOpacity = 0.0
        containerView.layer.shadowRadius = 0
        containerView.layer.shadowColor = UIColor.clear.cgColor
    }
}
