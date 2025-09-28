//
//  WholeCanvasTableViewCell.swift
//  chatcanvas
//
//  Created by Müge Deniz on 23.04.2025.
//

import UIKit
import SDWebImage

protocol WholeCanvasTableViewCellDelegate: AnyObject {
    func didSelectCategory(_ category: BackgroundCategory)
}

class WholeCanvasTableViewCell: UITableViewCell {
    private var classicCategories: [BackgroundCategory] = []
    private var popularCategories: [BackgroundCategory] = []
    
    weak var delegate: WholeCanvasTableViewCellDelegate?
    private var backgroundData: BackgroundModel?
    
    private var currentPageIndex: Int = 0 {
        didSet {
            updatePageControl()
        }
    }
    
    // Add a timer for auto-scrolling
    private var autoScrollTimer: Timer?
    private var isScrollingForward = true // To track the direction of scrolling
    
    private let classicCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .black
        cv.layer.cornerRadius = 15
        cv.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        cv.layer.shadowColor = UIColor.black.cgColor
        cv.layer.shadowOffset = CGSize(width: 0, height: 3)
        cv.layer.shadowRadius = 4
        cv.layer.shadowOpacity = 0.3
        cv.clipsToBounds = false
        return cv
    }()
    
    private let popularCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .black
        cv.isScrollEnabled = false
        return cv
    }()
    
    private let pageControl: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.3)
        view.layer.cornerRadius = 2
        view.isHidden = true // Initially hidden
        return view
    }()
    
    private let pageIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.orange
        view.layer.cornerRadius = 2
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .black
        contentView.clipsToBounds = false
        setupViews()
        setupCollectionViews()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        contentView.backgroundColor = .black
        classicCollectionView.backgroundColor = .black
        popularCollectionView.backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stopAutoScroll()
        pageControl.isHidden = true // Hide page control when cell is reused
    }
    
    func configure(with data: BackgroundModel) {
        let localizedCategories = data.localizedCategories()
        
        self.classicCategories = localizedCategories.filter { category in
            data.response.classic.contains { $0.type == category.type }
        }
        self.popularCategories = localizedCategories.filter { category in
            data.response.popular.contains { $0.type == category.type }
        }
        
        classicCollectionView.reloadData()
        popularCollectionView.reloadData()
        
        // Add a delay to show the page control
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.pageControl.isHidden = self.classicCategories.count <= 1
            self.updatePageControl()
        }
        
        popularCollectionView.layoutIfNeeded()
        popularCollectionView.heightAnchor.constraint(equalToConstant: popularCollectionView.contentSize.height).isActive = true
        
        // Start auto-scrolling after configuring the cell
        startAutoScroll()
    }
    
    private func setupViews() {
        contentView.addSubview(classicCollectionView)
        contentView.addSubview(popularCollectionView)
        contentView.addSubview(pageControl)
        pageControl.addSubview(pageIndicator)
        
        classicCollectionView.translatesAutoresizingMaskIntoConstraints = false
        popularCollectionView.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            classicCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            classicCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            classicCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            classicCollectionView.heightAnchor.constraint(equalToConstant: 440),
            
            popularCollectionView.topAnchor.constraint(equalTo: classicCollectionView.bottomAnchor, constant: 20),
            popularCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            popularCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            popularCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            pageControl.bottomAnchor.constraint(equalTo: classicCollectionView.bottomAnchor, constant: -2),
            pageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            pageControl.widthAnchor.constraint(equalToConstant: 60),
            pageControl.heightAnchor.constraint(equalToConstant: 4),
            
            pageIndicator.leadingAnchor.constraint(equalTo: pageControl.leadingAnchor),
            pageIndicator.topAnchor.constraint(equalTo: pageControl.topAnchor),
            pageIndicator.bottomAnchor.constraint(equalTo: pageControl.bottomAnchor),
            pageIndicator.widthAnchor.constraint(equalTo: pageControl.widthAnchor, multiplier: 1/3)
        ])
    }
    
    private func setupCollectionViews() {
        classicCollectionView.delegate = self
        classicCollectionView.dataSource = self
        classicCollectionView.register(TopThreeCollectionViewCell.self, forCellWithReuseIdentifier: "TopThreeCollectionViewCell")
        
        popularCollectionView.delegate = self
        popularCollectionView.dataSource = self
        popularCollectionView.register(BottomCardCollectionViewCell.self, forCellWithReuseIdentifier: "BottomCardCollectionViewCell")
    }
    
    private func updatePageControl() {
        guard classicCategories.count > 0 else { return }
        let pageWidth = pageControl.frame.width / CGFloat(classicCategories.count)
        UIView.animate(withDuration: 0.2) {
            self.pageIndicator.transform = CGAffineTransform(translationX: CGFloat(self.currentPageIndex) * pageWidth, y: 0)
        }
    }
    
    // Function to start the auto-scroll timer
    private func startAutoScroll() {
        // Invalidate any existing timer
        stopAutoScroll()
        
        // Start a new timer that fires every 3 seconds
        autoScrollTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.autoScroll()
        }
    }
    
    // Function to stop the auto-scroll timer
    private func stopAutoScroll() {
        autoScrollTimer?.invalidate()
        autoScrollTimer = nil
    }
    
    private func autoScroll() {
        guard classicCategories.count > 0 else { return }
        
        if currentPageIndex < classicCategories.count - 1 {
            currentPageIndex += 1
        } else {
            currentPageIndex = 0
        }
        
        let indexPath = IndexPath(item: currentPageIndex, section: 0)
        classicCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

extension WholeCanvasTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == classicCollectionView ? classicCategories.count : popularCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == classicCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopThreeCollectionViewCell", for: indexPath) as! TopThreeCollectionViewCell
            cell.configure(with: classicCategories[indexPath.item])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BottomCardCollectionViewCell", for: indexPath) as! BottomCardCollectionViewCell
            cell.configure(with: popularCategories[indexPath.item])
            cell.delegate = self 
            return cell
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == classicCollectionView {
            let pageWidth = scrollView.frame.width
            currentPageIndex = Int(scrollView.contentOffset.x / pageWidth)
            // Reset the timer when the user manually scrolls
            startAutoScroll()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == classicCollectionView {
            let selectedCategory = classicCategories[indexPath.item]
            delegate?.didSelectCategory(selectedCategory)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == classicCollectionView {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        } else {
            let width = (collectionView.frame.width - 16) / 2
            return CGSize(width: width, height: 160)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView == classicCollectionView ? 0 : 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView == classicCollectionView ? 0 : 8
    }
}

extension WholeCanvasTableViewCell: BottomCardCollectionViewCellDelegate {
    func didTapCell(with category: BackgroundCategory) {
        delegate?.didSelectCategory(category)
    }
}
