//
//  StickerViewController.swift
//  chatcanvas
//
//  Created by Müge Deniz on 27.04.2025.
//

import UIKit

protocol StickerViewControllerDelegate: AnyObject {
    func didFinishAddingStickers(image: UIImage)
}

class StickerViewController: UIViewController, UIGestureRecognizerDelegate {
    // MARK: - Properties
    weak var delegate: StickerViewControllerDelegate?
    private var selectedImage: UIImage?
    private var activeSticker: DraggableStickerView?
    
    private let stickers: [(category: String, items: [String])] = [
        ("Popular", ["🔥", "✨", "💯", "❤️", "🥇", "🎉", "🚀", "🌟", "🦄", "👑", "💎", "🥈", "🥉", "🏆", "🎆", "🎇", "🎊", "🎈", "🪄", "🪐", "🦋", "🧩", "🧸", "🪅", "🎂", "🎁"]),
        ("Smileys", ["😀", "😃", "😂", "😍", "🥰", "😎", "🤩", "😜", "🥳", "😇", "😋", "😏", "😌", "😙", "😚", "😘", "😗", "😆", "😅", "🤣", "😄", "😁", "🙂", "🙃", "😉"]),
        ("Animals", ["🐶", "🐱", "🦊", "🐻", "🐼", "🦁", "🐯", "🐸", "🐵", "🦄", "🐰", "🐹", "🐭", "🐨", "🐷", "🐮", "🐔", "🐧", "🦆", "🦉", "🦇", "🐺", "🐗", "🐴", "🦋"]),
        ("Food", ["🍔", "🍟", "🍕", "🌭", "🍦", "🍩", "🍰", "🍫", "🍿", "🍉", "🍎", "🍒", "🍇", "🍓", "🍑", "🍍", "🥝", "🥑", "🥦", "🥕", "🌽", "🍅", "🍆", "🥔"]),
        ("Social", ["💬", "👋", "🤝", "🙏", "👍", "👎", "👏", "🙌", "🤙", "🫶", "💌", "📱", "📸", "💻", "🖥️", "🖱️", "⌨️", "📞", "☎️", "📟", "📠", "📺", "📻", "🎧"]),
        ("Nature", ["🌿", "🌸", "🌻", "🌈", "🌞", "🌙", "⭐️", "🌊", "🍀", "🍁", "🌲", "🌳", "🌴", "🌵", "🌾", "🌼", "🌺", "🌹", "🌷", "🌱", "🪴", "🍂", "🍃", "🌍"]),
        ("Art", ["🎨", "🖌️", "🖼️", "🎭", "🎬", "🎵", "🎤", "🎧", "🎷", "🎸", "🎺", "🎻", "🥁", "🎹", "🪕", "🩰", "🎪", "🎫", "🎟️", "🎞️", "📸", "🎥", "📽️", "🎬"]),
        ("Surprise", ["🎁", "🎈", "🎊", "🎂", "🪅", "🧸", "🪄", "🪐", "🦋", "🧩", "🎉", "🎆", "🎇", "💎", "👑", "🥇", "🥈", "🥉", "🏆", "🎯", "🎮", "🕹️", "🎲", "🧸"])
    ]
    
    private var selectedCategoryIndex: Int = 0
    
    // MARK: - UI Components
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
        iv.isUserInteractionEnabled = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    private let categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 14
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    private let stickersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Sticker"
        lbl.font = UIFont(name: "Cousine-Bold", size: 22)
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    // MARK: - Lifecycle
    init(image: UIImage?) {
        self.selectedImage = image
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.09, green: 0.10, blue: 0.12, alpha: 1.0)
        setupUI()
        setupCollectionViews()
        let indexPath = IndexPath(item: 0, section: 0)
        categoryCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
        collectionView(categoryCollectionView, didSelectItemAt: indexPath)
    }

    // MARK: - Setup
    private func setupUI() {
        view.addSubview(navBar)
        navBar.addSubview(backButton)
        navBar.addSubview(doneButton)
        navBar.addSubview(titleLabel)
        view.addSubview(imageContainer)
        imageContainer.addSubview(imageView)
        view.addSubview(categoryCollectionView)
        view.addSubview(stickersCollectionView)

        imageView.image = selectedImage

        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 54),

            backButton.leadingAnchor.constraint(equalTo: navBar.leadingAnchor, constant: 12),
            backButton.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 36),
            backButton.heightAnchor.constraint(equalToConstant: 36),

            doneButton.trailingAnchor.constraint(equalTo: navBar.trailingAnchor, constant: -12),
            doneButton.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),

            titleLabel.centerXAnchor.constraint(equalTo: navBar.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),

            imageContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            imageContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.52),

            imageView.topAnchor.constraint(equalTo: imageContainer.topAnchor, constant: 16),
            imageView.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: -16),
            imageView.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor, constant: -16),

            categoryCollectionView.topAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 32),
            categoryCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            categoryCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.92),
            categoryCollectionView.heightAnchor.constraint(equalToConstant: 44),

            stickersCollectionView.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor, constant: 16),
            stickersCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stickersCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.92),
            stickersCollectionView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }

    private func setupCollectionViews() {
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")

        stickersCollectionView.delegate = self
        stickersCollectionView.dataSource = self
        stickersCollectionView.register(StickerCell.self, forCellWithReuseIdentifier: "StickerCell")
    }

    // MARK: - Actions
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    @objc private func doneButtonTapped() {
        for case let stickerView as DraggableStickerView in imageView.subviews {
            if let deleteButton = stickerView.subviews.first(where: { $0 is UIButton }) {
                deleteButton.isHidden = true
            }
        }
        activeSticker = nil
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, 0.0)
        imageView.drawHierarchy(in: imageView.bounds, afterScreenUpdates: true)
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = finalImage {
            delegate?.didFinishAddingStickers(image: image)
        }
        dismiss(animated: true)
    }
    @objc private func deleteButtonTapped(_ sender: UIButton) {
        guard let stickerView = sender.superview as? DraggableStickerView else { return }
        UIView.animate(withDuration: 0.2, animations: {
            stickerView.transform = stickerView.transform.scaledBy(x: 0.1, y: 0.1)
            stickerView.alpha = 0
        }) { _ in
            stickerView.removeFromSuperview()
            if stickerView == self.activeSticker {
                self.activeSticker = nil
            }
        }
    }
    private func addSticker(text: String) {
        let stickerView = DraggableStickerView()
        stickerView.text = text
        stickerView.font = .systemFont(ofSize: 50)
        stickerView.backgroundColor = .clear
        stickerView.textAlignment = .center
        stickerView.isUserInteractionEnabled = true

        let deleteButton = UIButton(type: .system)
        deleteButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        deleteButton.tintColor = .white
        deleteButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        deleteButton.layer.cornerRadius = 12
        deleteButton.isHidden = true
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)

        imageView.addSubview(stickerView)
        stickerView.addSubview(deleteButton)

        stickerView.frame = CGRect(x: imageView.bounds.midX - 50, y: imageView.bounds.midY - 50, width: 100, height: 100)

        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: stickerView.topAnchor, constant: -8),
            deleteButton.trailingAnchor.constraint(equalTo: stickerView.trailingAnchor, constant: 8),
            deleteButton.widthAnchor.constraint(equalToConstant: 24),
            deleteButton.heightAnchor.constraint(equalToConstant: 24)
        ])

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(_:)))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))

        panGesture.delegate = self
        pinchGesture.delegate = self
        rotationGesture.delegate = self
        tapGesture.delegate = self

        stickerView.addGestureRecognizer(panGesture)
        stickerView.addGestureRecognizer(pinchGesture)
        stickerView.addGestureRecognizer(rotationGesture)
        stickerView.addGestureRecognizer(tapGesture)

        activeSticker = stickerView
        handleTap(tapGesture)
    }

    // MARK: - Gesture Handlers
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let stickerView = gesture.view else { return }
        switch gesture.state {
        case .began:
            UIView.animate(withDuration: 0.2) {
                stickerView.transform = stickerView.transform.scaledBy(x: 1.1, y: 1.1)
            }
        case .changed:
            let translation = gesture.translation(in: imageView)
            stickerView.center = CGPoint(
                x: stickerView.center.x + translation.x,
                y: stickerView.center.y + translation.y
            )
            gesture.setTranslation(.zero, in: imageView)
        case .ended, .cancelled:
            UIView.animate(withDuration: 0.2) {
                stickerView.transform = stickerView.transform.scaledBy(x: 1/1.1, y: 1/1.1)
            }
        default:
            break
        }
    }
    @objc private func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard let stickerView = gesture.view as? DraggableStickerView else { return }
        if gesture.state == .began || gesture.state == .changed {
            stickerView.transform = stickerView.transform.scaledBy(x: gesture.scale, y: gesture.scale)
            gesture.scale = 1.0
        }
    }
    @objc private func handleRotation(_ gesture: UIRotationGestureRecognizer) {
        guard let stickerView = gesture.view as? DraggableStickerView else { return }
        if gesture.state == .began || gesture.state == .changed {
            stickerView.transform = stickerView.transform.rotated(by: gesture.rotation)
            gesture.rotation = 0
        }
    }
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        guard let stickerView = gesture.view as? DraggableStickerView else { return }
        if let previousSticker = activeSticker, previousSticker != stickerView {
            if let deleteButton = previousSticker.subviews.first(where: { $0 is UIButton }) {
                deleteButton.isHidden = true
            }
        }
        if let deleteButton = stickerView.subviews.first(where: { $0 is UIButton }) {
            deleteButton.isHidden = false
            stickerView.superview?.bringSubviewToFront(stickerView)
        }
        activeSticker = stickerView
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension StickerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return stickers.count
        }
        return stickers[selectedCategoryIndex].items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
            let cat = stickers[indexPath.item]
            cell.configure(with: cat.category)
            cell.isSelected = indexPath.item == selectedCategoryIndex
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StickerCell", for: indexPath) as! StickerCell
            let sticker = stickers[selectedCategoryIndex].items[indexPath.item]
            cell.configure(with: sticker)
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCollectionView {
            let category = stickers[indexPath.item]
            let width = category.category.size(withAttributes: [.font: UIFont.systemFont(ofSize: 15, weight: .medium)]).width + 44
            return CGSize(width: width, height: 38)
        } else {
            return CGSize(width: 64, height: 64)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            selectedCategoryIndex = indexPath.item
            for cell in categoryCollectionView.visibleCells {
                if let categoryCell = cell as? CategoryCell {
                    categoryCell.isSelected = false
                }
            }
            if let selectedCell = categoryCollectionView.cellForItem(at: indexPath) as? CategoryCell {
                selectedCell.isSelected = true
            }
            categoryCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            stickersCollectionView.reloadData()
            stickersCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
        } else {
            let sticker = stickers[selectedCategoryIndex].items[indexPath.item]
            addSticker(text: sticker)
        }
    }
}

// MARK: - DraggableStickerView
class DraggableStickerView: UILabel {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let biggerBounds = bounds.insetBy(dx: -20, dy: -20)
        return biggerBounds.contains(point)
    }
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let button = subviews.first(where: { $0 is UIButton }),
           !button.isHidden,
           button.frame.contains(point) {
            return button
        }
        return super.hitTest(point, with: event)
    }
}

// MARK: - CategoryCell
class CategoryCell: UICollectionViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Cousine-Bold", size: 14) ?? .boldSystemFont(ofSize: 14) 
        label.textAlignment = .center
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    private func setupUI() {
        let gradient = CAGradientLayer()
        gradient.colors = [
//                    UIColor(red: 1.0, green: 0.55, blue: 0.20, alpha: 1.0).cgColor, // Warm medium orange (RGB: 255, 140, 51)
//                    UIColor(red: 1.0, green: 0.65, blue: 0.30, alpha: 1.0).cgColor  // Bright orange (RGB: 255, 166, 77)
                ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.frame = bounds
        gradient.cornerRadius = 16
        contentView.layer.insertSublayer(gradient, at: 0)
        contentView.layer.cornerRadius = 16
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    func configure(with title: String) {
        titleLabel.text = title
    }
    override var isSelected: Bool {
        didSet {
            contentView.layer.borderColor = isSelected ? UIColor.systemYellow.cgColor : UIColor.clear.cgColor
            contentView.layer.shadowColor = isSelected ? UIColor.systemYellow.cgColor : UIColor.clear.cgColor
            contentView.layer.shadowOpacity = isSelected ? 0.4 : 0.0
            contentView.layer.shadowRadius = isSelected ? 8 : 0
            contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        }
    }
}

// MARK: - StickerCell
class StickerCell: UICollectionViewCell {
    private let stickerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 36, weight: .bold)
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
        contentView.layer.cornerRadius = 14
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.18
        contentView.layer.shadowRadius = 8
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.addSubview(stickerLabel)
        NSLayoutConstraint.activate([
            stickerLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stickerLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    func configure(with sticker: String) {
        stickerLabel.text = sticker
        animatePop()
    }
    private func animatePop() {
        stickerLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.18, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
            self.stickerLabel.transform = .identity
        }, completion: nil)
    }
    override var isSelected: Bool {
        didSet {
            if isSelected {
                contentView.layer.borderWidth = 2
                contentView.layer.borderColor = UIColor(red: 0.0, green: 0.8, blue: 0.4, alpha: 1.0).cgColor
                contentView.layer.shadowColor = UIColor(red: 0.0, green: 0.8, blue: 0.4, alpha: 0.7).cgColor
                contentView.layer.shadowOpacity = 1.0
                contentView.layer.shadowRadius = 16
                contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
            } else {
                contentView.layer.borderWidth = 0
                contentView.layer.borderColor = UIColor.clear.cgColor
                contentView.layer.shadowColor = UIColor.black.cgColor
                contentView.layer.shadowOpacity = 0.18
                contentView.layer.shadowRadius = 8
                contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
            }
        }
    }
}
