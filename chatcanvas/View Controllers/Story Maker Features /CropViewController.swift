//
//  CropViewController.swift
//  chatcanvas
//
//  Created by Müge Deniz on 27.04.2025.
//

import UIKit

protocol EditViewControllerDelegate: AnyObject {
    func didFinishEditing(image: UIImage?)
}

class CropViewController: UIViewController {
    weak var delegate: EditViewControllerDelegate?
    private let image: UIImage?
    private var originalImage: UIImage?
    private var selectedRatio: CGFloat = 0

    private let aspectRatios: [(title: String, icon: String, ratio: CGFloat)] = [
        ("Original", "rectangle.dashed", 0),
        ("1:1", "square", 1.0),
        ("4:3", "rectangle.landscape", 4.0/3.0),
        ("3:4", "rectangle.portrait", 3.0/4.0),
        ("16:9", "rectangle.landscape", 16.0/9.0),
        ("9:16", "rectangle.portrait", 9.0/16.0),
        ("3:2", "rectangle.landscape", 3.0/2.0),
        ("2:3", "rectangle.portrait", 2.0/3.0),
        ("21:9", "rectangle.landscape", 21.0/9.0),
        ("9:21", "rectangle.portrait", 9.0/21.0)
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
        lbl.text = "Crop"
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
        v.layer.cornerRadius = 32
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
    private let aspectRatioCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 28, bottom: 0, right: 28)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    // MARK: - Init
    init(image: UIImage?) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Lifecycle
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
        view.addSubview(aspectRatioCollectionView)

        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)

        aspectRatioCollectionView.delegate = self
        aspectRatioCollectionView.dataSource = self
        aspectRatioCollectionView.register(ModernAspectRatioCell.self, forCellWithReuseIdentifier: "ModernAspectRatioCell")

        if let image = image {
            originalImage = image
            imageView.image = image
        }

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

            aspectRatioCollectionView.topAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 24),
            aspectRatioCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            aspectRatioCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.92),
            aspectRatioCollectionView.heightAnchor.constraint(equalToConstant: 100) // Adjusted to match new cell height
        ])
    }

    // MARK: - Actions
    @objc private func backButtonTapped() { dismiss(animated: true) }
    @objc private func doneButtonTapped() {
        delegate?.didFinishEditing(image: imageView.image)
        dismiss(animated: true)
    }

    private func cropImage(_ image: UIImage, to aspectRatio: CGFloat) -> UIImage {
        if aspectRatio == 0 { return image }
        let imageSize = image.size
        var cropRect: CGRect
        if aspectRatio > 1 {
            let newWidth = imageSize.height * aspectRatio
            if newWidth <= imageSize.width {
                let x = (imageSize.width - newWidth) / 2
                cropRect = CGRect(x: x, y: 0, width: newWidth, height: imageSize.height)
            } else {
                let newHeight = imageSize.width / aspectRatio
                let y = (imageSize.height - newHeight) / 2
                cropRect = CGRect(x: 0, y: y, width: imageSize.width, height: newHeight)
            }
        } else {
            let newHeight = imageSize.width / aspectRatio
            if newHeight <= imageSize.height {
                let y = (imageSize.height - newHeight) / 2
                cropRect = CGRect(x: 0, y: y, width: imageSize.width, height: newHeight)
            } else {
                let newWidth = imageSize.height * aspectRatio
                let x = (imageSize.width - newWidth) / 2
                cropRect = CGRect(x: x, y: 0, width: newWidth, height: imageSize.height)
            }
        }
        if let cgImage = image.cgImage?.cropping(to: cropRect) {
            return UIImage(cgImage: cgImage)
        }
        return image
    }
}

// MARK: - CollectionView
extension CropViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { aspectRatios.count }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ModernAspectRatioCell", for: indexPath) as! ModernAspectRatioCell
        let option = aspectRatios[indexPath.item]
        if let originalImage = originalImage {
            let previewImage = cropImage(originalImage, to: option.ratio)
            cell.configure(title: option.title, icon: option.icon, isSelected: option.ratio == selectedRatio, preview: previewImage)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 100) // Increased from 64x84 to 80x100
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let option = aspectRatios[indexPath.item]
        selectedRatio = option.ratio
        if let originalImage = originalImage {
            let croppedImage = cropImage(originalImage, to: option.ratio)
            imageView.image = croppedImage
        }
        collectionView.reloadData()
    }
}

// MARK: - ModernAspectRatioCell
class ModernAspectRatioCell: UICollectionViewCell {
    private let glowView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    private let previewView = UIImageView()
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(white: 0.13, alpha: 0.95)
        contentView.layer.cornerRadius = 30 // Increased from 24 to 30 to scale with cell size
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.10
        contentView.layer.shadowRadius = 8
        contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        previewView.contentMode = .scaleAspectFill
        previewView.clipsToBounds = true
        previewView.layer.cornerRadius = 28 // Increased from 22 to 28
        previewView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(glowView)
        glowView.addSubview(previewView)
        
        titleLabel.font = UIFont(name: "Cousine-Bold", size: 13) ?? .boldSystemFont(ofSize: 13)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.7
        titleLabel.numberOfLines = 1
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            glowView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            glowView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10), // Increased from 8 to 10
            glowView.widthAnchor.constraint(equalToConstant: 56), // Increased from 44 to 56
            glowView.heightAnchor.constraint(equalToConstant: 56), // Increased from 44 to 56
            
            previewView.centerXAnchor.constraint(equalTo: glowView.centerXAnchor),
            previewView.centerYAnchor.constraint(equalTo: glowView.centerYAnchor),
            previewView.widthAnchor.constraint(equalToConstant: 56), // Increased from 44 to 56
            previewView.heightAnchor.constraint(equalToConstant: 56), // Increased from 44 to 56
            
            titleLabel.topAnchor.constraint(equalTo: glowView.bottomAnchor, constant: 10), // Increased from 8 to 10
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8) // Increased from -6 to -8
        ])
        
        glowView.layer.cornerRadius = 28 // Increased from 22 to 28 to match previewView
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(title: String, icon: String, isSelected: Bool, preview: UIImage) {
        previewView.image = preview
        titleLabel.text = title
        
        if isSelected {
            // Apply green glow to glowView
            glowView.layer.borderWidth = 2
            glowView.layer.borderColor = UIColor(red: 0.0, green: 0.8, blue: 0.4, alpha: 1.0).cgColor
            glowView.layer.shadowColor = UIColor(red: 0.0, green: 0.8, blue: 0.4, alpha: 0.7).cgColor
            glowView.layer.shadowOpacity = 1.0
            glowView.layer.shadowRadius = 16
            glowView.layer.shadowOffset = CGSize(width: 0, height: 0)
            
            // Apply the same animation as in FilterPreviewCell
            UIView.animate(withDuration: 0.18, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
                self.glowView.transform = CGAffineTransform(scaleX: 1.10, y: 1.10)
            }, completion: { _ in
                self.glowView.transform = .identity
            })
            
            // Keep the cell's shadow as is (black shadow)
            contentView.layer.borderWidth = 0
            contentView.layer.shadowColor = UIColor.black.cgColor
            contentView.layer.shadowOpacity = 0.10
            contentView.layer.shadowRadius = 8
            contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
        } else {
            // Reset glowView when not selected
            glowView.layer.borderWidth = 0
            glowView.layer.shadowOpacity = 0.0
            
            // Reset cell's appearance
            contentView.layer.borderWidth = 0
            contentView.layer.shadowColor = UIColor.black.cgColor
            contentView.layer.shadowOpacity = 0.10
            contentView.layer.shadowRadius = 8
            contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        previewView.image = nil
        titleLabel.text = nil
        glowView.layer.borderWidth = 0
        glowView.layer.shadowOpacity = 0.0
        contentView.layer.borderWidth = 0
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.10
        contentView.layer.shadowRadius = 8
        contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
}
