//
//  RotateViewController.swift
//  chatcanvas
//
//  Created by Müge Deniz on 27.04.2025.
//

import UIKit

protocol RotateViewControllerDelegate: AnyObject {
    func didFinishRotating(image: UIImage)
}

class RotateViewController: UIViewController {
    // MARK: - Properties
    weak var delegate: RotateViewControllerDelegate?
    private var selectedImage: UIImage?
    private var currentRotation: CGFloat = 0
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.09, green: 0.10, blue: 0.12, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
    
    private let imageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.10)
        view.layer.cornerRadius = 28
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.10
        view.layer.shadowRadius = 16
        view.layer.shadowOffset = CGSize(width: 0, height: 8)
        return view
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 24
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let rotateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "rotate.right")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 28, weight: .semibold)
        ), for: .normal)
        button.tintColor = .white.withAlphaComponent(0.9)
        button.backgroundColor = UIColor(red: 0.0, green: 0.8, blue: 0.4, alpha: 0.13)
        button.layer.cornerRadius = 35
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 6
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Rotate"
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
        view.backgroundColor = UIColor(red: 0.09, green: 0.10, blue: 0.12, alpha: 1.0)
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.addSubview(containerView)
        containerView.addSubview(navBar)
        navBar.addSubview(backButton)
        navBar.addSubview(doneButton)
        navBar.addSubview(titleLabel)
        containerView.addSubview(imageContainerView)
        imageContainerView.addSubview(imageView)
        containerView.addSubview(rotateButton)
        
        imageView.image = selectedImage
        
        // Add button targets
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        rotateButton.addTarget(self, action: #selector(rotateButtonTapped), for: .touchUpInside)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 54),
            
            backButton.leadingAnchor.constraint(equalTo: navBar.leadingAnchor, constant: 12),
            backButton.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 36),
            backButton.heightAnchor.constraint(equalToConstant: 36),
            
            doneButton.trailingAnchor.constraint(equalTo: navBar.trailingAnchor, constant: -12),
            doneButton.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: navBar.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            
            imageContainerView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -20),
            imageContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            imageContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            imageContainerView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.52),
            
            imageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor, constant: -16),
            imageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: -16),
            
            rotateButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            rotateButton.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: 32),
            rotateButton.widthAnchor.constraint(equalToConstant: 70),
            rotateButton.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        // Add subtle animation to rotate button
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1.0
        scaleAnimation.toValue = 1.05
        scaleAnimation.duration = 0.8
        scaleAnimation.autoreverses = true
        scaleAnimation.repeatCount = .infinity
        rotateButton.layer.add(scaleAnimation, forKey: "pulse")
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        dismiss(animated: true)
    }
    
    @objc private func doneButtonTapped() {
        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        guard let rotatedImage = imageView.image else { return }
        delegate?.didFinishRotating(image: rotatedImage)
        dismiss(animated: true)
    }
    
    @objc private func rotateButtonTapped() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        // Rotate image by 90 degrees (no transform animation)
        if let rotatedImage = imageView.image?.rotated(by: .pi/2) {
            imageView.image = rotatedImage
        }
    }
}

// MARK: - UIImage Extension
extension UIImage {
    func rotated(by radians: CGFloat) -> UIImage? {
        let destRect = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: radians))
        let roundedDestRect = CGRect(
            x: destRect.origin.x.rounded(),
            y: destRect.origin.y.rounded(),
            width: destRect.width.rounded(),
            height: destRect.height.rounded()
        )
        
        UIGraphicsBeginImageContextWithOptions(roundedDestRect.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        context.translateBy(x: roundedDestRect.width / 2, y: roundedDestRect.height / 2)
        context.rotate(by: radians)
        draw(in: CGRect(
            x: -size.width / 2,
            y: -size.height / 2,
            width: size.width,
            height: size.height
        ))
        
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return rotatedImage
    }
}
