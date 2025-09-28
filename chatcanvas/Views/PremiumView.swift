//
//  PremiumView.swift
//  chatcanvas
//
//  Created by Müge Deniz on 25.04.2025.
//

import UIKit

class PremiumView: UIView {
    // MARK: - Properties
    var onDismiss: (() -> Void)? // Closure for dismissal

    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1.0)
        view.layer.cornerRadius = 24
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(white: 1, alpha: 0.1).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "PREMIUM"
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = UIColor(red: 0.85, green: 0.65, blue: 0.13, alpha: 1.0)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let headlineLabel: UILabel = {
        let label = UILabel()
        label.text = "Unlock Everything"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let featuresStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = UIColor(white: 1, alpha: 0.5)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let subscribeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Subscribe Now", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(red: 0.85, green: 0.65, blue: 0.13, alpha: 1.0)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let termsLabel: UILabel = {
        let label = UILabel()
        label.text = "Auto-renews monthly. Cancel anytime."
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(white: 1, alpha: 0.6)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Animation Layers
    private var particleEmitter: CAEmitterLayer?
    private var gradientLayer: CAGradientLayer?
    private var pulseAnimation: CABasicAnimation?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupFeatures()
        setupAnimations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupView() {
        backgroundColor = UIColor(white: 0, alpha: 0.8)
        
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(headlineLabel)
        containerView.addSubview(featuresStack)
        containerView.addSubview(subscribeButton)
        containerView.addSubview(termsLabel)
        containerView.addSubview(closeButton)
        
        closeButton.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
        subscribeButton.addTarget(self, action: #selector(handleSubscribe), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 320),
            
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            headlineLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            headlineLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            headlineLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            
            featuresStack.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 24),
            featuresStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            featuresStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            
            subscribeButton.topAnchor.constraint(equalTo: featuresStack.bottomAnchor, constant: 32),
            subscribeButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            subscribeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            subscribeButton.heightAnchor.constraint(equalToConstant: 50),
            
            termsLabel.topAnchor.constraint(equalTo: subscribeButton.bottomAnchor, constant: 12),
            termsLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            termsLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            termsLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupFeatures() {
        let features = [
            ("🎨", "All Art Styles", "Classics, Modern, Abstract and more"),
            ("🌌", "Exclusive Content", "Premium-only collections and styles"),
            ("✨", "Advanced Tools", "Unlock all creative tools and effects"),
            ("📱", "No Ads", "Enjoy an uninterrupted creative experience")
        ]
        
        features.forEach { (icon, title, subtitle) in
            let featureView = createFeatureView(icon: icon, title: title, subtitle: subtitle)
            featuresStack.addArrangedSubview(featureView)
        }
    }
    
    private func createFeatureView(icon: String, title: String, subtitle: String) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let iconLabel = UILabel()
        iconLabel.text = icon
        iconLabel.font = .systemFont(ofSize: 24)
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = .systemFont(ofSize: 14, weight: .regular)
        subtitleLabel.textColor = UIColor(white: 1, alpha: 0.7)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStack.axis = .vertical
        textStack.spacing = 2
        textStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(iconLabel)
        view.addSubview(textStack)
        
        NSLayoutConstraint.activate([
            iconLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            iconLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            iconLabel.widthAnchor.constraint(equalToConstant: 40),
            
            textStack.leadingAnchor.constraint(equalTo: iconLabel.trailingAnchor, constant: 12),
            textStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            view.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        return view
    }
    
    // MARK: - Animations
    private func setupAnimations() {
        gradientLayer = CAGradientLayer()
        gradientLayer?.colors = [
            UIColor(red: 0.15, green: 0.15, blue: 0.16, alpha: 1.0).cgColor,
            UIColor(red: 0.10, green: 0.10, blue: 0.11, alpha: 1.0).cgColor
        ]
        gradientLayer?.locations = [0, 1]
        gradientLayer?.frame = containerView.bounds
        containerView.layer.insertSublayer(gradientLayer!, at: 0)
        
        let borderLayer = CAGradientLayer()
        borderLayer.colors = [
            UIColor(red: 0.85, green: 0.65, blue: 0.13, alpha: 0.8).cgColor,
            UIColor(red: 0.95, green: 0.75, blue: 0.23, alpha: 0.8).cgColor,
            UIColor(red: 0.85, green: 0.65, blue: 0.13, alpha: 0.8).cgColor
        ]
        borderLayer.startPoint = CGPoint(x: 0, y: 0.5)
        borderLayer.endPoint = CGPoint(x: 1, y: 0.5)
        borderLayer.frame = CGRect(x: 0, y: 0, width: containerView.bounds.width, height: containerView.bounds.height)
        borderLayer.cornerRadius = 24
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 2
        shapeLayer.path = UIBezierPath(roundedRect: containerView.bounds.insetBy(dx: 2, dy: 2), cornerRadius: 22).cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = nil
        borderLayer.mask = shapeLayer
        
        containerView.layer.addSublayer(borderLayer)
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-0.5, 0.5, 1.5]
        animation.toValue = [1.5, 2.5, 3.5]
        animation.duration = 3
        animation.repeatCount = .infinity
        borderLayer.add(animation, forKey: "borderAnimation")
        
        pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation?.toValue = 1.03
        pulseAnimation?.duration = 1.0
        pulseAnimation?.autoreverses = true
        pulseAnimation?.repeatCount = .infinity
        pulseAnimation?.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        subscribeButton.layer.add(pulseAnimation!, forKey: "pulse")
        
        setupParticleEmitter()
    }
    
    private func setupParticleEmitter() {
        let emitter = CAEmitterLayer()
        emitter.emitterPosition = CGPoint(x: containerView.bounds.width / 2, y: -50)
        emitter.emitterShape = .line
        emitter.emitterSize = CGSize(width: containerView.bounds.width, height: 1)
        
        let cell = CAEmitterCell()
        cell.birthRate = 5
        cell.lifetime = 10
        cell.velocity = 50
        cell.velocityRange = 30
        cell.emissionLongitude = .pi
        cell.scale = 0.1
        cell.scaleRange = 0.05
        cell.contents = UIImage(systemName: "sparkle")?.withTintColor(.white).cgImage
        cell.color = UIColor(red: 0.85, green: 0.65, blue: 0.13, alpha: 0.7).cgColor
        
        emitter.emitterCells = [cell]
        containerView.layer.addSublayer(emitter)
        particleEmitter = emitter
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = containerView.bounds
    }
    
    // MARK: - Actions
    @objc private func dismissTapped() {
        onDismiss?()
    }
    
    @objc private func handleSubscribe() {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.impactOccurred()
        
        // TODO: Implement actual subscription logic (e.g., StoreKit)
        // For now, simulate a successful subscription
        UIView.animate(withDuration: 0.2, animations: {
            self.subscribeButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.subscribeButton.transform = .identity
            }
            // Simulate subscription success
            GlobalHelper.isPremiumActive() // Update premium status (temporary)
            self.onDismiss?()
        })
    }
}
