////
////  TopThreeCollectionViewCell.swift
////  chatcanvas
////
////  Created by Müge Deniz on 23.04.2025.
////
//
//import UIKit
//import SDWebImage
//
//class TopThreeCollectionViewCell: UICollectionViewCell {
//    private let containerView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .black
//        view.layer.cornerRadius = 15
//        view.layer.shadowColor = UIColor.black.cgColor
//        view.layer.shadowOffset = CGSize(width: 0, height: 3)
//        view.layer.shadowRadius = 4
//        view.layer.shadowOpacity = 0.1
//        return view
//    }()
//    
//    private let imageView: UIImageView = {
//        let iv = UIImageView()
//        iv.contentMode = .scaleAspectFill
//        iv.clipsToBounds = true
//        iv.layer.cornerRadius = 8
//        iv.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//        return iv
//    }()
//    
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.cousineBold(ofSize: 22)
//        label.textColor = .white
//        label.textAlignment = .center
//        return label
//    }()
//    
//    private let subtitleLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.cousineRegular(ofSize: 16)
//        label.textColor = .lightGray
//        label.textAlignment = .center
//        label.numberOfLines = 0
//        return label
//    }()
//    
//    private let premiumIcon: UIImageView = {
//        let iv = UIImageView(image: UIImage(named: "ic_premium_ic"))
//        iv.contentMode = .scaleAspectFit
//        iv.isHidden = true // Varsayılan olarak gizli
//        return iv
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupViews()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setupViews() {
//        backgroundColor = .black
//        contentView.addSubview(containerView)
//        containerView.addSubview(imageView)
//        containerView.addSubview(titleLabel)
//        containerView.addSubview(subtitleLabel)
//        containerView.addSubview(premiumIcon)
//        
//        containerView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
//        premiumIcon.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            
//            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
//            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
//            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
//            imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.8),
//            
//            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 14),
//            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
//            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
//            
//            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
//            subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
//            subtitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
//            subtitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -12),
//            
//            // Premium ikonu sağ alt köşede
//            premiumIcon.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
//            premiumIcon.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
//            premiumIcon.widthAnchor.constraint(equalToConstant: 24),
//            premiumIcon.heightAnchor.constraint(equalToConstant: 24)
//        ])
//    }
//    
//    func configure(with category: BackgroundCategory) {
//        titleLabel.text = category.title
//        subtitleLabel.text = category.subtitle
////        if GlobalHelper.isPremiumActive() {
////            premiumIcon.isHidden = true
////        } else {
////            premiumIcon.isHidden = !category.premium
////        }
//        guard let url = URL(string: category.image) else { return }
//        imageView.sd_imageIndicator = SDWebImageActivityIndicator.medium
//        imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
//    }
//}


//
//  TopThreeCollectionViewCell.swift
//  chatcanvas
//
//  Created by Müge Deniz on 23.04.2025.
//

import UIKit
import SDWebImage

class TopThreeCollectionViewCell: UICollectionViewCell {
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 15
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.1
        return view
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.cousineBold(ofSize: 22)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.cousineRegular(ofSize: 16)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let premiumIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "ic_premium_ic"))
        iv.contentMode = .scaleAspectFit
        iv.isHidden = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .black
        contentView.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(premiumIcon)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
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
            imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.8),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 14),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            subtitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            subtitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -12),
            
            premiumIcon.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            premiumIcon.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            premiumIcon.widthAnchor.constraint(equalToConstant: 24),
            premiumIcon.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func configure(with category: BackgroundCategory) {
        titleLabel.text = category.title
        subtitleLabel.text = category.subtitle
        // Simple premium check (replace with your actual premium logic)
        premiumIcon.isHidden = !category.premium
        guard let url = URL(string: category.image) else { return }
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.medium
        imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
    }
}
