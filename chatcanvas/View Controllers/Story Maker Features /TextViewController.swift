//
//  TextViewController.swift
//  chatcanvas
//
//  Created by Müge Deniz on 27.04.2025.
//

import UIKit

protocol TextViewControllerDelegate: AnyObject {
    func didFinishAddingText(image: UIImage)
}

class TextViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextViewDelegate {
    
    // MARK: - Collection View Data Source & Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == fontsCollectionView {
            return systemFonts.count
        } else {
            return colors.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == fontsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FontCell", for: indexPath) as! FontCell
            let font = systemFonts[indexPath.item]
            cell.configure(with: font.name, font: font.font)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorCell
            let color = colors[indexPath.item]
            cell.configure(with: color)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == fontsCollectionView {
            currentFont = systemFonts[indexPath.item].font
            activeTextView?.font = currentFont
        } else if collectionView == colorsCollectionView {
            currentColor = colors[indexPath.item]
            activeTextView?.textColor = currentColor
        }
    }
    
    // MARK: - Collection View Flow Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == fontsCollectionView {
            return CGSize(width: 100, height: 90) // Adjusted height for "Aa" and font name
        } else {
            return CGSize(width: 50, height: 50) // Size for color cells
        }
    }
    
    // MARK: - Properties
    weak var delegate: TextViewControllerDelegate?
    private var selectedImage: UIImage?
    private var activeTextView: DraggableTextView?
    private var currentFont: UIFont = .systemFont(ofSize: 30)
    private var currentColor: UIColor = .white
    
    private let systemFonts: [(name: String, font: UIFont)] = [
        ("Helvetica Neue", UIFont(name: "HelveticaNeue", size: 30) ?? .systemFont(ofSize: 30)),
        ("Helvetica Bold", UIFont(name: "HelveticaNeue-Bold", size: 30) ?? .systemFont(ofSize: 30)),
        ("Arial", UIFont(name: "ArialMT", size: 30) ?? .systemFont(ofSize: 30)),
        ("Avenir", UIFont(name: "Avenir-Book", size: 30) ?? .systemFont(ofSize: 30)),
        ("Avenir Next", UIFont(name: "AvenirNext-Regular", size: 30) ?? .systemFont(ofSize: 30)),
        ("Avenir Next Bold", UIFont(name: "AvenirNext-Bold", size: 30) ?? .systemFont(ofSize: 30)),
        ("Futura", UIFont(name: "Futura-Medium", size: 30) ?? .systemFont(ofSize: 30)),
        ("Futura Bold", UIFont(name: "Futura-Bold", size: 30) ?? .systemFont(ofSize: 30)),
        ("Georgia", UIFont(name: "Georgia", size: 30) ?? .systemFont(ofSize: 30)),
        ("Georgia Bold", UIFont(name: "Georgia-Bold", size: 30) ?? .systemFont(ofSize: 30)),
        ("Optima", UIFont(name: "Optima-Regular", size: 30) ?? .systemFont(ofSize: 30)),
        ("Optima Bold", UIFont(name: "Optima-Bold", size: 30) ?? .systemFont(ofSize: 30)),
        ("Palatino", UIFont(name: "Palatino-Roman", size: 30) ?? .systemFont(ofSize: 30)),
        ("Times New Roman", UIFont(name: "TimesNewRomanPSMT", size: 30) ?? .systemFont(ofSize: 30)),
        ("Verdana", UIFont(name: "Verdana", size: 30) ?? .systemFont(ofSize: 30)),
        ("Zapfino", UIFont(name: "Zapfino", size: 30) ?? .systemFont(ofSize: 30)),
        ("Menlo", UIFont(name: "Menlo-Regular", size: 30) ?? .systemFont(ofSize: 30)),
        ("SF Pro", UIFont(name: "SFProText-Regular", size: 30) ?? .systemFont(ofSize: 30)),
        ("Cousine", UIFont(name: "Cousine-Regular", size: 30) ?? .systemFont(ofSize: 30)),
        ("Chalkboard", UIFont(name: "ChalkboardSE-Regular", size: 30) ?? .systemFont(ofSize: 30)),
        ("Noteworthy", UIFont(name: "Noteworthy-Bold", size: 30) ?? .systemFont(ofSize: 30)),
        ("Gill Sans", UIFont(name: "GillSans", size: 30) ?? .systemFont(ofSize: 30)),
        ("Courier", UIFont(name: "Courier", size: 30) ?? .systemFont(ofSize: 30)),
        ("Courier Bold", UIFont(name: "Courier-Bold", size: 30) ?? .systemFont(ofSize: 30)),
        ("Marker Felt", UIFont(name: "MarkerFelt-Thin", size: 30) ?? .systemFont(ofSize: 30)),
        ("Papyrus", UIFont(name: "Papyrus", size: 30) ?? .systemFont(ofSize: 30)),
        ("Copperplate", UIFont(name: "Copperplate", size: 30) ?? .systemFont(ofSize: 30)),
        ("Baskerville", UIFont(name: "Baskerville", size: 30) ?? .systemFont(ofSize: 30)),
        ("Didot", UIFont(name: "Didot", size: 30) ?? .systemFont(ofSize: 30)),
        ("Hoefler Text", UIFont(name: "HoeflerText-Regular", size: 30) ?? .systemFont(ofSize: 30))
    ]
    
    private let colors: [UIColor] = [
        .white,
        .black,
        UIColor(red: 0.0, green: 0.8, blue: 0.4, alpha: 1.0),
        UIColor(red: 0.98, green: 0.24, blue: 0.24, alpha: 1.0),
        UIColor(red: 0.24, green: 0.48, blue: 0.98, alpha: 1.0),
        UIColor(red: 0.98, green: 0.73, blue: 0.24, alpha: 1.0),
        UIColor(red: 0.73, green: 0.24, blue: 0.98, alpha: 1.0),
        UIColor(red: 0.98, green: 0.24, blue: 0.73, alpha: 1.0),
        UIColor(red: 0.0, green: 0.9, blue: 0.8, alpha: 1.0),
        UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0),
        UIColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0)
    ]
    
    // MARK: - UI Components
    private let blurNavBar: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.backgroundColor = UIColor(red: 0.06, green: 0.07, blue: 0.08, alpha: 1.0) // Match main view background
        view.layer.cornerRadius = 0
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let navBarStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let doneButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Done", for: .normal)
        btn.titleLabel?.font = UIFont(name: "Cousine-Bold", size: 18)
        btn.tintColor = UIColor(red: 0.0, green: 0.8, blue: 0.4, alpha: 1.0)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let imageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.05)
        view.clipsToBounds = true
        view.layer.cornerRadius = 28
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.18
        view.layer.shadowRadius = 18
        view.layer.shadowOffset = CGSize(width: 0, height: 8)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let addTextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Text", for: .normal)
        button.titleLabel?.font = UIFont(name: "Cousine-Bold", size: 16) ?? .boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor(red: 0.0, green: 0.8, blue: 0.4, alpha: 1.0)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 16
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.12
        button.layer.shadowRadius = 8
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let fontsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 14
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(white: 1.0, alpha: 0.08)
        cv.layer.cornerRadius = 22
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private let colorsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 14
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear // Removed background for color cells
        cv.layer.cornerRadius = 22
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Text"
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        setupCollectionView()
        setupGestureRecognizers()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.06, green: 0.07, blue: 0.08, alpha: 1.0)
        view.addSubview(blurNavBar)
        view.addSubview(navBarStack)
        navBarStack.addArrangedSubview(backButton)
        navBarStack.addArrangedSubview(titleLabel)
        navBarStack.addArrangedSubview(doneButton)
        view.addSubview(imageContainerView)
        imageContainerView.addSubview(imageView)
        view.addSubview(colorsCollectionView)
        view.addSubview(addTextButton)
        view.addSubview(fontsCollectionView)
        imageView.image = selectedImage
        
        // Add button targets
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        addTextButton.addTarget(self, action: #selector(addTextButtonTapped), for: .touchUpInside)
        
        // Constraints
        NSLayoutConstraint.activate([
            blurNavBar.topAnchor.constraint(equalTo: view.topAnchor),
            blurNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurNavBar.heightAnchor.constraint(equalToConstant: 60),
            
            navBarStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            navBarStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            navBarStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            navBarStack.heightAnchor.constraint(equalToConstant: 44),
            
            imageContainerView.topAnchor.constraint(equalTo: blurNavBar.bottomAnchor, constant: 50),
            imageContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            imageContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            imageContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.48),
            
            imageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor),
            
            colorsCollectionView.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: 24),
            colorsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            colorsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            colorsCollectionView.heightAnchor.constraint(equalToConstant: 60),
            
            addTextButton.topAnchor.constraint(equalTo: colorsCollectionView.bottomAnchor, constant: 24),
            addTextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addTextButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.55),
            addTextButton.heightAnchor.constraint(equalToConstant: 50),
            
            fontsCollectionView.topAnchor.constraint(equalTo: addTextButton.bottomAnchor, constant: 24),
            fontsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            fontsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            fontsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Setup Helpers
    private func setupCollectionView() {
        fontsCollectionView.delegate = self
        fontsCollectionView.dataSource = self
        fontsCollectionView.register(FontCell.self, forCellWithReuseIdentifier: "FontCell")
        
        colorsCollectionView.delegate = self
        colorsCollectionView.dataSource = self
        colorsCollectionView.register(ColorCell.self, forCellWithReuseIdentifier: "ColorCell")
    }
    
    private func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        imageView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    @objc private func doneButtonTapped() {
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, 0.0)
        imageView.drawHierarchy(in: imageView.bounds, afterScreenUpdates: true)
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = finalImage {
            delegate?.didFinishAddingText(image: image)
        }
        dismiss(animated: true)
    }
    
    @objc private func addTextButtonTapped() {
        let textView = DraggableTextView()
        textView.font = currentFont
        textView.text = "Double tap to edit"
        textView.textColor = currentColor
        textView.backgroundColor = .clear
        textView.delegate = self
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        let deleteButton = UIButton(type: .system)
        deleteButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        deleteButton.tintColor = .white
        deleteButton.isHidden = true
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.addTarget(self, action: #selector(deleteTextViewTapped(_:)), for: .touchUpInside)
        
        imageView.addSubview(textView)
        textView.addSubview(deleteButton)
        
        textView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        textView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        textView.widthAnchor.constraint(lessThanOrEqualTo: imageView.widthAnchor, constant: -40).isActive = true
        
        deleteButton.topAnchor.constraint(equalTo: textView.topAnchor, constant: -10).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: 10).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        
        textView.addGestureRecognizer(panGesture)
        textView.addGestureRecognizer(pinchGesture)
        textView.addGestureRecognizer(doubleTapGesture)
        
        activeTextView = textView
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc private func deleteTextViewTapped(_ sender: UIButton) {
        guard let textView = sender.superview as? DraggableTextView else { return }
        textView.removeFromSuperview()
        if textView == activeTextView {
            activeTextView = nil
        }
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let textView = gesture.view as? DraggableTextView else { return }
        let translation = gesture.translation(in: imageView)
        textView.center = CGPoint(
            x: textView.center.x + translation.x,
            y: textView.center.y + translation.y
        )
        gesture.setTranslation(.zero, in: imageView)
    }
    
    @objc private func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard let textView = gesture.view as? DraggableTextView else { return }
        if gesture.state == .began || gesture.state == .changed {
            textView.transform = textView.transform.scaledBy(x: gesture.scale, y: gesture.scale)
            gesture.scale = 1.0
        }
    }
    
    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        guard let textView = gesture.view as? DraggableTextView else { return }
        textView.isEditable = true
        textView.becomeFirstResponder()
    }
}

// MARK: - DraggableTextView
class DraggableTextView: UITextView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        // Increase the hit area for better touch handling
        let biggerBounds = bounds.insetBy(dx: -20, dy: -20)
        return biggerBounds.contains(point)
    }
}

// MARK: - FontCell
class FontCell: UICollectionViewCell {
    private let previewLabel: UILabel = {
        let label = UILabel()
        label.text = "Aa"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(white: 1, alpha: 0.92)
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 18
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.10
        contentView.layer.shadowRadius = 8
        contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
        contentView.addSubview(previewLabel)
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            previewLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            previewLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            previewLabel.heightAnchor.constraint(equalToConstant: 38),
            nameLabel.topAnchor.constraint(equalTo: previewLabel.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with name: String, font: UIFont) {
        nameLabel.text = name
        previewLabel.font = font.withSize(32)
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                contentView.layer.borderWidth = 2
                contentView.layer.borderColor = UIColor(red: 0.0, green: 0.8, blue: 0.4, alpha: 1.0).cgColor
                contentView.layer.shadowOpacity = 0.25
                contentView.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
            } else {
                contentView.layer.borderWidth = 0
                contentView.layer.borderColor = UIColor.clear.cgColor
                contentView.layer.shadowOpacity = 0.10
                contentView.transform = .identity
            }
        }
    }
}

// MARK: - ColorCell
class ColorCell: UICollectionViewCell {
    private let colorCircle: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(colorCircle)
        NSLayoutConstraint.activate([
            colorCircle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorCircle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorCircle.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7),
            colorCircle.heightAnchor.constraint(equalTo: colorCircle.widthAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with color: UIColor) {
        colorCircle.backgroundColor = color
        colorCircle.layer.cornerRadius = (bounds.width * 0.7) / 2
        colorCircle.layer.masksToBounds = true
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                colorCircle.layer.borderWidth = 3
                colorCircle.layer.borderColor = UIColor(red: 0.0, green: 0.8, blue: 0.4, alpha: 1.0).cgColor
                colorCircle.layer.shadowColor = UIColor(red: 0.0, green: 0.8, blue: 0.4, alpha: 0.5).cgColor
                colorCircle.layer.shadowOpacity = 0.7
                colorCircle.layer.shadowRadius = 8
                colorCircle.layer.shadowOffset = CGSize(width: 0, height: 0)
                colorCircle.transform = CGAffineTransform(scaleX: 1.18, y: 1.18)
            } else {
                colorCircle.layer.borderWidth = 0
                colorCircle.layer.borderColor = UIColor.clear.cgColor
                colorCircle.layer.shadowColor = UIColor.clear.cgColor
                colorCircle.layer.shadowOpacity = 0.0
                colorCircle.transform = .identity
            }
        }
    }
}
