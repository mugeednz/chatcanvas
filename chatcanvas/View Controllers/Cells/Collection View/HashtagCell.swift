//
//  HashtagCell.swift
//  chatcanvas
//
//  Created by Müge Deniz on 26.04.2025.
//

import UIKit

class HashtagCell: UICollectionViewCell {
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.cousineRegular(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])

        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
    }

    func configure(with hashtag: String, isSelected: Bool) {
        label.text = hashtag
        if isSelected {
            layer.shadowColor = UIColor.orange.cgColor
            layer.shadowOpacity = 0.9
            layer.shadowOffset = CGSize(width: 0, height: 0)
            layer.shadowRadius = 8
        } else {
            layer.shadowColor = nil
            layer.shadowOpacity = 0
            layer.shadowOffset = .zero
            layer.shadowRadius = 0
        }
    }
}
