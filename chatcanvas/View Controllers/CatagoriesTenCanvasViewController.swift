//
//  CatagoriesTenCanvasViewController.swift
//  chatcanvas
//
//  Created by Müge Deniz on 23.04.2025.
//

import UIKit

class CatagoriesTenCanvasViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private let collectionView: UICollectionView = {
        let layout = MagazineLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .black
        cv.showsVerticalScrollIndicator = true
        return cv
    }()
    
    private let backButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        btn.layer.cornerRadius = 20
        btn.layer.masksToBounds = true
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        btn.layer.shadowColor = UIColor.white.cgColor
        btn.layer.shadowOpacity = 0.2
        btn.layer.shadowRadius = 4
        btn.layer.shadowOffset = CGSize.zero
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        gradient.colors = [
            UIColor.white.withAlphaComponent(0.2).cgColor,
            UIColor.white.withAlphaComponent(0.05).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        btn.layer.insertSublayer(gradient, at: 0)
        return btn
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.cousineBold(ofSize: 22)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    var selectedCategory: BackgroundCategory?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupViews()
        setupCollectionView()
    }
    
    private func setupViews() {
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.backgroundColor = .black
        backButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        titleLabel.text = selectedCategory?.title ?? "Category"
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BottomCardCollectionViewCell.self, forCellWithReuseIdentifier: "BottomCardCollectionViewCell")
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let images = selectedCategory?.images, !images.isEmpty else {
            let alert = UIAlertController(title: "No Images", message: "No images available for this category.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return 0
        }
        return min(images.count, 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BottomCardCollectionViewCell", for: indexPath) as! BottomCardCollectionViewCell
        
        if let images = selectedCategory?.images, indexPath.row < images.count {
            let art = images[indexPath.row]
            cell.configure(withImageURL: art.image, showLabels: false)
            
            // Fade-in animation
            cell.alpha = 0
            cell.transform = CGAffineTransform(translationX: 0, y: 20)
            UIView.animate(withDuration: 0.5, delay: 0.05 * Double(indexPath.item), options: .curveEaseOut) {
                cell.alpha = 1
                cell.transform = .identity
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let images = selectedCategory?.images, indexPath.item < images.count else { return }
        let selectedArt = images[indexPath.item]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailDowlandViewController") as? DetailDowlandViewController {
            detailVC.selectedArt = selectedArt
            detailVC.selectedCategory = selectedCategory 
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

// Custom Magazine Layout
class MagazineLayout: UICollectionViewLayout {
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override func prepare() {
        super.prepare()
        cache.removeAll()
        contentHeight = 0
        
        guard let collectionView = collectionView else { return }
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        let padding: CGFloat = 16
        let columnWidth = contentWidth / 2 - padding / 2
        var yOffset: CGFloat = 0
        var currentIndex = 0
        
        while currentIndex < numberOfItems {
            let patternIndex = currentIndex % 5 // Repeat pattern every 5 items
            var frame: CGRect
            
            if patternIndex == 0 {
                // Large cell (full width)
                frame = CGRect(x: 0, y: yOffset, width: contentWidth, height: contentWidth * 0.6)
            } else if patternIndex == 1 || patternIndex == 2 {
                // Two small cells side by side
                let xOffset = (patternIndex == 1) ? 0 : columnWidth + padding
                frame = CGRect(x: xOffset, y: yOffset, width: columnWidth, height: columnWidth * 1.2)
            } else {
                // Medium cells
                let xOffset = (patternIndex == 3) ? 0 : columnWidth + padding
                frame = CGRect(x: xOffset, y: yOffset, width: columnWidth, height: columnWidth * 0.8)
            }
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: currentIndex, section: 0))
            attributes.frame = frame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            if patternIndex == 0 || patternIndex == 2 || patternIndex == 4 {
                yOffset += frame.height + padding
            }
            
            currentIndex += 1
        }
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { $0.frame.intersects(rect) }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache.first { $0.indexPath == indexPath }
    }
}
