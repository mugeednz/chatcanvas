//
//  HashtagViewController.swift
//  chatcanvas
//
//  Created by Müge Deniz on 26.04.2025.
//

import UIKit
import collection_view_layouts

class HashtagViewController: UIViewController, LayoutDelegate {
    private var collectionView: UICollectionView!
    private var selectedHashtags: Set<String> = []
    var onDismiss: (() -> Void)?
    
    private let hashtagCategories: [String: [String]] = [
        "Like": [
            "#like4like", "#likeforlike", "#instalike", "#likes", "#likeforlikes",
            "#l4l", "#f4f", "#tagsforlikes", "#likeforfollow", "#likeback",
            "#likeme", "#likers", "#liketeam", "#likesforlikes", "#instalikes",
            "#likelove", "#likestagram", "#likeplease", "#likeforlikeback", "#likeitup"
        ],
        "Follow": [
            "#followme", "#follow", "#follow4follow", "#followforfollow", "#foryou",
            "#foryoupage", "#fyp", "#explorepage", "#followback", "#follower",
            "#followers", "#followus", "#follows", "#followforlike", "#followtrain",
            "#followalways", "#followmeplease", "#followmeto", "#follow4followback", "#followgram"
        ],
        "Trends": [
            "#trending", "#viral", "#reels", "#explore", "#trendingreels",
            "#reelitfeelit", "#exploremore", "#viralreels", "#instagood", "#photooftheday",
            "#instadaily", "#bestoftheday", "#trend", "#viralpost", "#reelsinstagram",
            "#exploreeverything", "#trendingnow", "#viralvideos", "#instamood", "#pop",
            "#new", "#hot", "#insta", "#memes", "#newpost", "#share", "#comment",
            "#instaphoto", "#edit", "#youtube"
        ]
    ]
    
    // Track expanded sections
    private var expandedSections: Set<String> = []
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Hashtags"
        label.textColor = .white
        label.font = UIFont.cousineRegular(ofSize: 24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Select hashtags to enhance your post's visibility!"
        label.textColor = .white.withAlphaComponent(0.7)
        label.font = UIFont.cousineRegular(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let closeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "xmark"), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        btn.layer.cornerRadius = 17.5
        btn.layer.masksToBounds = true
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        btn.layer.shadowColor = UIColor.white.cgColor
        btn.layer.shadowOpacity = 0.2
        btn.layer.shadowRadius = 4
        btn.layer.shadowOffset = CGSize.zero
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let copyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Copy", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.cousineRegular(ofSize: 16)
        button.backgroundColor = UIColor(red: 0.0, green: 0.8, blue: 0.4, alpha: 1.0)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    private let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "hashtag_bg")
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let overlayView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private var closeButtonGradient: CAGradientLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        // Arka plan görseli ve overlay ekle
        view.insertSubview(backgroundImageView, at: 0)
        view.insertSubview(overlayView, aboveSubview: backgroundImageView)
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        setupUI()
        setupCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateCloseButtonGradient()
    }
    

        private func setupUI() {
            view.addSubview(titleLabel)
            view.addSubview(descriptionLabel)
            view.addSubview(closeButton)
            view.addSubview(copyButton)
            
            // Close Button size
            NSLayoutConstraint.activate([
                closeButton.widthAnchor.constraint(equalToConstant: 35),
                closeButton.heightAnchor.constraint(equalToConstant: 35)
            ])
            
            // Copy Button size
            NSLayoutConstraint.activate([
                copyButton.widthAnchor.constraint(equalToConstant: 100),
                copyButton.heightAnchor.constraint(equalToConstant: 44)
            ])
            
            
            // Layout constraints
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                
                descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
                descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                
                closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                
                copyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                copyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
            
            closeButton.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
            copyButton.addTarget(self, action: #selector(copyTapped), for: .touchUpInside)
            
            // Gradient for close button
            closeButtonGradient = CAGradientLayer()
            closeButtonGradient?.colors = [
                UIColor.white.withAlphaComponent(0.2).cgColor,
                UIColor.white.withAlphaComponent(0.05).cgColor
            ]
            closeButtonGradient?.startPoint = CGPoint(x: 0, y: 0)
            closeButtonGradient?.endPoint = CGPoint(x: 1, y: 1)
            if let gradient = closeButtonGradient {
                closeButton.layer.insertSublayer(gradient, at: 0)
            }
        }
    
    private func updateCloseButtonGradient() {
        closeButtonGradient?.frame = closeButton.bounds
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(HashtagCell.self, forCellWithReuseIdentifier: "HashtagCell")
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -84) // Adjusted to leave space for the button
        ])
    }
    @objc private func dismissTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func copyTapped() {
        let hashtagString = selectedHashtags.joined(separator: ",")
        UIPasteboard.general.string = hashtagString
        
        let alert = UIAlertController(title: "Copied!", message: hashtagString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func toggleSection(_ sender: UIButton) {
        let section = hashtagCategories.keys.sorted()[sender.tag]
        if expandedSections.contains(section) {
            expandedSections.remove(section)
        } else {
            expandedSections.insert(section)
        }
        collectionView.reloadData()
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            sender.imageView?.transform = self.expandedSections.contains(section) ?
            CGAffineTransform(rotationAngle: .pi / 2) :
            CGAffineTransform.identity
        }, completion: nil)
    }
    
    func cellSize(indexPath: IndexPath) -> CGSize {
        let section = hashtagCategories.keys.sorted()[indexPath.section]
        let hashtag = hashtagCategories[section]![indexPath.item]
        let font = UIFont.cousineRegular(ofSize: 16)
        let attributes = [NSAttributedString.Key.font: font]
        let size = (hashtag as NSString).boundingRect(
            with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 50),
            options: [.usesLineFragmentOrigin],
            attributes: attributes,
            context: nil
        ).size
        let width = ceil(size.width) + 20
        let height = ceil(size.height) + 10
        return CGSize(width: width, height: height)
    }
}

extension HashtagViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return hashtagCategories.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionKey = hashtagCategories.keys.sorted()[section]
        return expandedSections.contains(sectionKey) ? hashtagCategories[sectionKey]!.count : 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HashtagCell", for: indexPath) as! HashtagCell
        let sectionKey = hashtagCategories.keys.sorted()[indexPath.section]
        let hashtag = hashtagCategories[sectionKey]![indexPath.item]
        cell.configure(with: hashtag, isSelected: selectedHashtags.contains(hashtag))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionKey = hashtagCategories.keys.sorted()[indexPath.section]
        let hashtag = hashtagCategories[sectionKey]![indexPath.item]
        if selectedHashtags.contains(hashtag) {
            selectedHashtags.remove(hashtag)
        } else {
            selectedHashtags.insert(hashtag)
        }
        collectionView.reloadItems(at: [indexPath])
        copyButton.isHidden = selectedHashtags.isEmpty
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionHeaderView
        let sectionKey = hashtagCategories.keys.sorted()[indexPath.section]
        header.configure(with: sectionKey, isExpanded: expandedSections.contains(sectionKey))
        header.arrowButton.tag = indexPath.section
        header.arrowButton.addTarget(self, action: #selector(toggleSection(_:)), for: .touchUpInside)
        return header
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize(indexPath: indexPath)
    }
}
