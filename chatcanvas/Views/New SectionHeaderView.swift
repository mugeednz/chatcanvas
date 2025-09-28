//
//  SectionHeaderView.swift
//  chatcanvas
//
//  Created by Müge Deniz on 27.04.2025.
//

import UIKit

class SectionHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "SectionHeader"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.cousineRegular(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let arrowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(titleLabel)
        addSubview(arrowButton)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            arrowButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            arrowButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowButton.widthAnchor.constraint(equalToConstant: 24),
            arrowButton.heightAnchor.constraint(equalToConstant: 24)
        ])

        backgroundColor = UIColor.black.withAlphaComponent(0.3)
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }

    func configure(with title: String, isExpanded: Bool) {
        titleLabel.text = title
        arrowButton.imageView?.transform = isExpanded ? CGAffineTransform(rotationAngle: .pi / 2) : .identity
    }
}
