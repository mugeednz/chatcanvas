//
//  BottomCardCollectionViewCell.swift
//  chatcanvas
//
//  Created by Müge Deniz on 23.04.2025.
//

import UIKit
import SDWebImage

protocol BottomCardCollectionViewCellDelegate: AnyObject {
    func didTapCell(with category: BackgroundCategory)
}

class BottomCardCollectionViewCell: UICollectionViewCell {
    weak var delegate: BottomCardCollectionViewCellDelegate?
    private var category: BackgroundCategory?
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.5
        view.clipsToBounds = false
        return view
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 16
        iv.backgroundColor = .black
        return iv
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.layer.cornerRadius = 16
        view.isHidden = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.cousineBold(ofSize: 14)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.cousineRegular(ofSize: 12)
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let premiumIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "ic_premium_ic"))
        iv.contentMode = .scaleAspectFit
        iv.isHidden = true
        return iv
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .black
        contentView.backgroundColor = .black
        contentView.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(overlayView)
        containerView.addSubview(loadingIndicator)
        overlayView.addSubview(titleLabel)
        overlayView.addSubview(subtitleLabel)
        containerView.addSubview(premiumIcon)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        premiumIcon.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            overlayView.topAnchor.constraint(equalTo: containerView.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            
            titleLabel.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor, constant: -10),
            titleLabel.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -12),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            subtitleLabel.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 12),
            subtitleLabel.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -12),
            
            premiumIcon.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8),
            premiumIcon.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 8),
            premiumIcon.widthAnchor.constraint(equalToConstant: 25),
            premiumIcon.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.cancelsTouchesInView = false
        containerView.addGestureRecognizer(tapGesture)
        containerView.isUserInteractionEnabled = true
    }
    
    @objc private func handleTap() {
        UIView.animate(withDuration: 0.2) {
            self.containerView.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.containerView.transform = .identity
            }
            if let category = self.category {
                self.delegate?.didTapCell(with: category)
            }
        }
    }
    
    func configure(withImageURL imageURL: String, showLabels: Bool) {
        imageView.image = nil
        loadingIndicator.startAnimating()
        
        if let url = URL(string: imageURL) {
            imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder")) { [weak self] (image, error, cacheType, url) in
                self?.loadingIndicator.stopAnimating()
                if error != nil {
                    print("Failed to load image")
                } else {
                    print("Successfully loaded image")
                }
            }
        } else {
            imageView.image = UIImage(named: "placeholder")
            loadingIndicator.stopAnimating()
        }
    }
    
    func configure(with category: BackgroundCategory) {
        self.category = category
        
        // Always show title and subtitle for all categories
        titleLabel.text = category.title
        subtitleLabel.text = category.subtitle
        overlayView.isHidden = false
        titleLabel.isHidden = false
        subtitleLabel.isHidden = false
        
        // Show premium icon only if:
        // 1. Category is premium AND
        // 2. User doesn't have premium access
        let shouldShowPremiumIcon = category.premium && !GlobalHelper.isPremiumActive()
        premiumIcon.isHidden = !shouldShowPremiumIcon
        
        // Load image
        loadingIndicator.startAnimating()
        imageView.image = nil
        
        if let url = URL(string: category.image) {
            imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder")) { [weak self] (_, _, _, _) in
                self?.loadingIndicator.stopAnimating()
            }
        } else {
            imageView.image = UIImage(named: "placeholder")
            loadingIndicator.stopAnimating()
        }
    }}
