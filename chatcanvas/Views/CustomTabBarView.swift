//
//  CustomTabBarView.swift
//  chatcanvas
//
//  Created by Müge Deniz on 26.04.2025.
//

import UIKit

class CustomTabBarView: UIView {
    // MARK: - UI Components
    private let mainButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(systemName: "photo")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .white.withAlphaComponent(0.7)
        btn.tag = 0
        btn.imageView?.contentMode = .scaleAspectFit
        btn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return btn
    }()
    
    private let hashtagButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(systemName: "number")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .white.withAlphaComponent(0.7)
        btn.tag = 1
        btn.imageView?.contentMode = .scaleAspectFit
        btn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return btn
    }()
    
    private let storyButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(systemName: "camera.filters")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .white.withAlphaComponent(0.7)
        btn.tag = 2
        btn.imageView?.contentMode = .scaleAspectFit
        btn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return btn
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.spacing = 40
        return stack
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        view.layer.cornerRadius = 30
        view.layer.masksToBounds = true
        return view
    }()
    
    private let blurView: UIVisualEffectView = {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterialDark))
        blur.layer.cornerRadius = 30
        blur.layer.masksToBounds = true
        return blur
    }()
    
    // MARK: - Properties
    var onButtonTapped: ((Int) -> Void)?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup
    private func setupView() {
        // Container setup
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            containerView.heightAnchor.constraint(equalToConstant: 60),
            
            blurView.topAnchor.constraint(equalTo: containerView.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        // Shadow setup
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: -2)
        containerView.layer.shadowRadius = 8
        containerView.layer.shadowOpacity = 0.3
        
        // StackView setup
        stackView.addArrangedSubview(mainButton)
        stackView.addArrangedSubview(hashtagButton)
        stackView.addArrangedSubview(storyButton)
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.8)
        ])
        
        // Button setup
        [mainButton, hashtagButton, storyButton].forEach { button in
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 40),
                button.heightAnchor.constraint(equalToConstant: 40)
            ])
            
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            
            let circleView = UIView()
            circleView.isUserInteractionEnabled = false
            circleView.backgroundColor = UIColor.white.withAlphaComponent(0.15)
            circleView.layer.cornerRadius = 20
            button.insertSubview(circleView, at: 0)
            
            circleView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                circleView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
                circleView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
                circleView.widthAnchor.constraint(equalToConstant: 40),
                circleView.heightAnchor.constraint(equalToConstant: 40)
            ])
        }
        
        updateSelectedButton(tag: 0)
    }
    
    // MARK: - Button Actions
    @objc private func buttonTapped(_ sender: UIButton) {
        animateButtonTap(sender)
        updateSelectedButton(tag: sender.tag)
        onButtonTapped?(sender.tag)
    }
    
    private func animateButtonTap(_ button: UIButton) {
        UIView.animate(withDuration: 0.15, animations: {
            button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.15) {
                button.transform = .identity
            }
        }
    }
    
     func updateSelectedButton(tag: Int) {
        [mainButton, hashtagButton, storyButton].forEach { button in
            let isSelected = button.tag == tag
            
            // Update tint color
            button.tintColor = isSelected ? .white : .white.withAlphaComponent(0.7)
            
            // Update background view
            if let circleView = button.subviews.first(where: { $0 is UIView }) {
                circleView.backgroundColor = isSelected ? UIColor.orange.withAlphaComponent(0.9) : UIColor.white.withAlphaComponent(0.15)
            }
            
            // Update shadow
            button.layer.shadowColor = isSelected ? UIColor.orange.cgColor : UIColor.clear.cgColor
            button.layer.shadowRadius = isSelected ? 6 : 0
            button.layer.shadowOpacity = isSelected ? 0.5 : 0
        }
    }
    
    // MARK: - Hit Testing
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !isHidden, alpha > 0.01, isUserInteractionEnabled else { return nil }
        
        for button in [mainButton, hashtagButton, storyButton] {
            let buttonPoint = convert(point, to: button)
            if button.point(inside: buttonPoint, with: event) {
                return button
            }
        }
        
        return super.hitTest(point, with: event)
    }
}
