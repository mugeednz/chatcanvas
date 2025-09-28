//
//  FilterViewController.swift
//  chatcanvas
//
//  Created by Müge Deniz on 27.04.2025.
//

import UIKit
import CoreImage

protocol FilterViewControllerDelegate: AnyObject {
    func didFinishFiltering(image: UIImage?)
}

class FilterViewController: UIViewController {
    weak var delegate: FilterViewControllerDelegate?
    private let image: UIImage?
    private var originalImage: UIImage?
    private var selectedFilterIndex: Int = 0
    private var cachedFilteredImages: [String: UIImage] = [:]
    private let context = CIContext(options: nil)

    // MARK: - Filters
    private let filters: [(title: String, filter: CIFilter?)] = [
        ("Normal", nil),
        ("Vivid", CIFilter(name: "CIColorControls")),
        ("Cool", CIFilter(name: "CIPhotoEffectProcess")),
        ("Warm", CIFilter(name: "CIPhotoEffectTransfer")),
        ("Noir", CIFilter(name: "CIPhotoEffectNoir")),
        ("Sepia", CIFilter(name: "CISepiaTone")),
        ("Fade", CIFilter(name: "CIPhotoEffectFade")),
        ("Instant", CIFilter(name: "CIPhotoEffectInstant")),
        ("Chrome", CIFilter(name: "CIPhotoEffectChrome")),
        ("Process", CIFilter(name: "CIPhotoEffectProcess")),
        ("Mono", CIFilter(name: "CIPhotoEffectMono")),
        ("Tonal", CIFilter(name: "CIPhotoEffectTonal")),
        ("Dramatic", CIFilter(name: "CIPhotoEffectTransfer")),
        ("Posterize", CIFilter(name: "CIColorPosterize")),
        ("Bloom", CIFilter(name: "CIBloom")),
        ("Gloom", CIFilter(name: "CIGloom")),
        ("Invert", CIFilter(name: "CIColorInvert"))
    ]

    // MARK: - UI Elements
    private let navBar: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    private let backButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        btn.tintColor = .white
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Filter"
        lbl.font = UIFont(name: "Cousine-Bold", size: 22)
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    private let doneButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Done", for: .normal)
        btn.titleLabel?.font = UIFont(name: "Cousine-Bold", size: 18)
        btn.tintColor = UIColor(red: 0.0, green: 0.8, blue: 0.4, alpha: 1.0)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    private let imageContainer: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(white: 1, alpha: 0.10)
        v.layer.cornerRadius = 28
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.10
        v.layer.shadowRadius = 16
        v.layer.shadowOffset = CGSize(width: 0, height: 8)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 24
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    private let filterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    private let loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Applying filter..."
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Init
    init(image: UIImage?) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.09, green: 0.10, blue: 0.12, alpha: 1.0)
        setupUI()
    }

    private func setupUI() {
        view.addSubview(navBar)
        navBar.addSubview(backButton)
        navBar.addSubview(titleLabel)
        navBar.addSubview(doneButton)
        view.addSubview(imageContainer)
        imageContainer.addSubview(imageView)
        view.addSubview(filterCollectionView)
        view.addSubview(loadingView)
        loadingView.addSubview(loadingIndicator)
        loadingView.addSubview(loadingLabel)

        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)

        if let image = image {
            originalImage = image
            imageView.image = image
        }

        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self
        filterCollectionView.register(FilterPreviewCell.self, forCellWithReuseIdentifier: "FilterPreviewCell")

        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 54),

            backButton.leadingAnchor.constraint(equalTo: navBar.leadingAnchor, constant: 12),
            backButton.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 36),
            backButton.heightAnchor.constraint(equalToConstant: 36),

            titleLabel.centerXAnchor.constraint(equalTo: navBar.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),

            doneButton.trailingAnchor.constraint(equalTo: navBar.trailingAnchor, constant: -12),
            doneButton.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),

            imageContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            imageContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.52),

            imageView.topAnchor.constraint(equalTo: imageContainer.topAnchor, constant: 16),
            imageView.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: -16),
            imageView.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor, constant: -16),

            filterCollectionView.topAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 24),
            filterCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.92),
            filterCollectionView.heightAnchor.constraint(equalToConstant: 100),

            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            loadingIndicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor),

            loadingLabel.topAnchor.constraint(equalTo: loadingIndicator.bottomAnchor, constant: 12),
            loadingLabel.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor)
        ])
    }

    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    @objc private func doneButtonTapped() {
        delegate?.didFinishFiltering(image: imageView.image)
        dismiss(animated: true)
    }

    private func applyFilter(_ filter: String, to image: UIImage) -> UIImage {
        if let cachedImage = cachedFilteredImages[filter] {
            return cachedImage
        }
        let maxSize: CGFloat = 1024
        let scale = image.size.width > maxSize ? maxSize / image.size.width : 1.0
        let optimizedSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        UIGraphicsBeginImageContextWithOptions(optimizedSize, false, 1.0)
        image.draw(in: CGRect(origin: .zero, size: optimizedSize))
        let optimizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgImage = optimizedImage?.cgImage else { return image }
        let ciImage = CIImage(cgImage: cgImage)
        guard let filterTuple = filters.first(where: { $0.title == filter }),
              let filter = filterTuple.filter else {
            return image
        }
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        switch filter.name {
        case "CISepiaTone":
            filter.setValue(0.7, forKey: kCIInputIntensityKey)
        case "CIColorControls":
            filter.setValue(1.3, forKey: kCIInputSaturationKey)
            filter.setValue(1.1, forKey: kCIInputContrastKey)
        case "CIBloom":
            filter.setValue(1.0, forKey: kCIInputIntensityKey)
            filter.setValue(10.0, forKey: kCIInputRadiusKey)
        case "CIGloom":
            filter.setValue(1.0, forKey: kCIInputIntensityKey)
            filter.setValue(10.0, forKey: kCIInputRadiusKey)
        default:
            break
        }
        guard let outputImage = filter.outputImage,
              let cgOutputImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return image
        }
        let filteredImage = UIImage(cgImage: cgOutputImage)
        cachedFilteredImages[filter.name] = filteredImage
        return filteredImage
    }
}

// MARK: - FilterPreviewCell
class FilterPreviewCell: UICollectionViewCell {
    private let glowView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    private let previewImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Cousine-Bold", size: 13) ?? .boldSystemFont(ofSize: 13) // Increased from 13 to 16 to match CropViewController
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupUI() {
        contentView.backgroundColor = UIColor(white: 0.13, alpha: 0.95)
        contentView.layer.cornerRadius = 30
        contentView.layer.masksToBounds = false
        
        contentView.addSubview(glowView)
        glowView.addSubview(previewImageView)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            glowView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            glowView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10), // Adjusted to match CropViewController
            glowView.widthAnchor.constraint(equalToConstant: 60), // Slightly larger than previewImageView
            glowView.heightAnchor.constraint(equalToConstant: 60), // Slightly larger than previewImageView
            
            previewImageView.centerXAnchor.constraint(equalTo: glowView.centerXAnchor),
            previewImageView.centerYAnchor.constraint(equalTo: glowView.centerYAnchor),
            previewImageView.widthAnchor.constraint(equalToConstant: 56), // Slightly smaller than glowView
            previewImageView.heightAnchor.constraint(equalToConstant: 56), // Slightly smaller than glowView
            
            titleLabel.topAnchor.constraint(equalTo: glowView.bottomAnchor, constant: 10), // Adjusted to match CropViewController
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8) // Adjusted to match CropViewController
        ])
        
        glowView.layer.cornerRadius = 28 // Matches previewImageView
        previewImageView.layer.cornerRadius = 28 // Matches glowView
    }
    
    func configure(with image: UIImage, title: String, isSelected: Bool) {
        previewImageView.image = image
        titleLabel.text = title
        if isSelected {
            glowView.layer.borderWidth = 2
            glowView.layer.borderColor = UIColor(red: 0.0, green: 0.8, blue: 0.4, alpha: 1.0).cgColor
            glowView.layer.shadowColor = UIColor(red: 0.0, green: 0.8, blue: 0.4, alpha: 0.7).cgColor
            glowView.layer.shadowOpacity = 1.0
            glowView.layer.shadowRadius = 16
            glowView.layer.shadowOffset = CGSize(width: 0, height: 0)
            UIView.animate(withDuration: 0.18, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
                self.glowView.transform = CGAffineTransform(scaleX: 1.10, y: 1.10)
            }, completion: { _ in
                self.glowView.transform = .identity
            })
        } else {
            glowView.layer.borderWidth = 0
            glowView.layer.shadowOpacity = 0.0
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        previewImageView.image = nil
        titleLabel.text = nil
        glowView.layer.borderWidth = 0
        glowView.layer.shadowOpacity = 0.0
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension FilterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterPreviewCell", for: indexPath) as! FilterPreviewCell
        let filter = filters[indexPath.item]
        if let originalImage = originalImage {
            let filteredImage = filter.filter == nil ? originalImage : applyFilter(filter.title, to: originalImage)
            cell.configure(with: filteredImage, title: filter.title, isSelected: indexPath.item == selectedFilterIndex)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedFilterIndex = indexPath.item
        let filter = filters[indexPath.item]
        if let originalImage = originalImage {
            loadingView.isHidden = false
            loadingIndicator.startAnimating()
            let start = Date()
            DispatchQueue.global(qos: .userInitiated).async {
                let filteredImage = filter.filter == nil ? originalImage : self.applyFilter(filter.title, to: originalImage)
                let elapsed = Date().timeIntervalSince(start)
                let delay = max(0, 1.0 - elapsed)
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    self.imageView.image = filteredImage
                    self.loadingView.isHidden = true
                    collectionView.reloadData()
                    collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                }
            }
        }
    }
}
