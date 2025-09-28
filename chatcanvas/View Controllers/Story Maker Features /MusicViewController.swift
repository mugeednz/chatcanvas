//
//  MusicViewController.swift
//  chatcanvas
//
//  Created by Müge Deniz on 27.04.2025.
//

import UIKit
import AVFoundation

protocol MusicViewControllerDelegate: AnyObject {
    func didSelectMusic(image: UIImage?, title: String, url: URL)
}

struct MusicCategory {
    let title: String
    let color: UIColor
    let tracks: [MusicTrack]
}

struct MusicTrack {
    let name: String
    let fileName: String // mp3 dosya adı
}

class GradientLabel: UILabel {
    private var gradientLayer: CAGradientLayer?
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.removeFromSuperlayer()
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [UIColor.systemPink.cgColor, UIColor.systemOrange.cgColor, UIColor.systemYellow.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        layer.mask = nil
        layer.addSublayer(gradient)
        gradientLayer = gradient
        let textMask = CATextLayer()
        textMask.string = text
        textMask.font = font
        textMask.fontSize = font.pointSize
        textMask.frame = bounds
        textMask.foregroundColor = UIColor.black.cgColor
        textMask.contentsScale = UIScreen.main.scale
        gradient.mask = textMask
    }
}

class ModernTitleLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.font = UIFont(name: "Cousine-Bold", size: 22) ?? .boldSystemFont(ofSize: 22)
        self.textColor = .white
        self.textAlignment = .center
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MusicViewController: UIViewController {
    // MARK: - Properties
    weak var delegate: MusicViewControllerDelegate?
    private var player: AVAudioPlayer?
    private var selectedImage: UIImage?
    private var currentlyPlayingIndexPath: IndexPath?
    var selectedMusicTitle: String?
    var selectedMusicURL: URL?
    
    private let categories: [MusicCategory] = [
        MusicCategory(title: "Energy", color: UIColor.systemRed, tracks: [
            MusicTrack(name: "Fire Up", fileName: "energy1"),
            MusicTrack(name: "Adrenaline", fileName: "energy2"),
            MusicTrack(name: "Rush Hour", fileName: "energy3")
        ]),
        MusicCategory(title: "Summer", color: UIColor.systemYellow, tracks: [
            MusicTrack(name: "Sunset Beach", fileName: "summer1"),
            MusicTrack(name: "Tropical Vibes", fileName: "summer2"),
            MusicTrack(name: "Pool Party", fileName: "summer3")
        ]),
        MusicCategory(title: "Love", color: UIColor.systemPink, tracks: [
            MusicTrack(name: "Romantic Night", fileName: "love1"),
            MusicTrack(name: "Sweetheart", fileName: "love2"),
            MusicTrack(name: "Forever Us", fileName: "love3")
        ]),
        MusicCategory(title: "Inspiration", color: UIColor.systemBlue, tracks: [
            MusicTrack(name: "Dream Big", fileName: "inspiration1"),
            MusicTrack(name: "Rise Up", fileName: "inspiration2"),
            MusicTrack(name: "New Day", fileName: "inspiration3")
        ]),
        MusicCategory(title: "Happy", color: UIColor.systemGreen, tracks: [
            MusicTrack(name: "Smile On", fileName: "happy1"),
            MusicTrack(name: "Good Mood", fileName: "happy2"),
            MusicTrack(name: "Joyful", fileName: "happy3")
        ]),
        MusicCategory(title: "Cinematic", color: UIColor.systemIndigo, tracks: [
            MusicTrack(name: "Epic Journey", fileName: "cinematic1"),
            MusicTrack(name: "Movie Night", fileName: "cinematic2"),
            MusicTrack(name: "Dramatic", fileName: "cinematic3")
        ]),
        MusicCategory(title: "Party", color: UIColor.systemOrange, tracks: [
            MusicTrack(name: "Dance Floor", fileName: "party1"),
            MusicTrack(name: "Night Out", fileName: "party2"),
            MusicTrack(name: "Groove", fileName: "party3")
        ])
    ]
    
    // MARK: - UI Components
    private let blurNavBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.06, green: 0.07, blue: 0.08, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let navBarStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let modernTitleLabel: ModernTitleLabel = {
        let label = ModernTitleLabel()
        label.text = "Music"
        return label
    }()
    private let doneButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Done", for: .normal)
        btn.titleLabel?.font = UIFont(name: "Cousine-Bold", size: 18)
        btn.tintColor = UIColor(red: 0.0, green: 0.8, blue: 0.4, alpha: 1.0)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    private let previewImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 32
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    private let musicWaveformView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.0, green: 0.8, blue: 0.4, alpha: 0.15)
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 32
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
        setupUI()
        addWaveformAnimation()
        
        // Setup AVAudioSession for audio playback
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up AVAudioSession: \(error)")
        }
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.06, green: 0.07, blue: 0.08, alpha: 1.0)
        
        // Add subviews
        view.addSubview(blurNavBar)
        view.addSubview(navBarStack)
        navBarStack.addArrangedSubview(backButton)
        navBarStack.addArrangedSubview(modernTitleLabel)
        navBarStack.addArrangedSubview(doneButton)
        view.addSubview(previewImageView)
        view.addSubview(musicWaveformView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        
        previewImageView.image = selectedImage
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            blurNavBar.topAnchor.constraint(equalTo: view.topAnchor),
            blurNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurNavBar.heightAnchor.constraint(equalToConstant: 60),
            
            navBarStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            navBarStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            navBarStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            navBarStack.heightAnchor.constraint(equalToConstant: 54),
            
            previewImageView.topAnchor.constraint(equalTo: navBarStack.bottomAnchor, constant: 24),
            previewImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            previewImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            previewImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            musicWaveformView.topAnchor.constraint(equalTo: previewImageView.bottomAnchor, constant: 20),
            musicWaveformView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            musicWaveformView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            musicWaveformView.heightAnchor.constraint(equalToConstant: 32),
            
            scrollView.topAnchor.constraint(equalTo: musicWaveformView.bottomAnchor, constant: 28),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5),
            
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),

        ])
        
        for (catIndex, category) in categories.enumerated() {
            let catLabel = UILabel()
            catLabel.text = category.title
            catLabel.font = UIFont(name: "Cousine-Bold", size: 18) ?? .boldSystemFont(ofSize: 18)
            catLabel.textColor = .white
            catLabel.translatesAutoresizingMaskIntoConstraints = false
            contentStack.addArrangedSubview(catLabel)
            
            let trackScroll = UIScrollView()
            trackScroll.showsHorizontalScrollIndicator = false
            trackScroll.isUserInteractionEnabled = true
            trackScroll.translatesAutoresizingMaskIntoConstraints = false
            
            let trackStack = UIStackView()
            trackStack.axis = .horizontal
            trackStack.spacing = 16
            trackStack.isUserInteractionEnabled = true
            trackStack.translatesAutoresizingMaskIntoConstraints = false
            
            trackScroll.addSubview(trackStack)
            NSLayoutConstraint.activate([
                trackStack.topAnchor.constraint(equalTo: trackScroll.topAnchor),
                trackStack.leadingAnchor.constraint(equalTo: trackScroll.leadingAnchor, constant: 16),
                trackStack.trailingAnchor.constraint(equalTo: trackScroll.trailingAnchor, constant: -16),
                trackStack.bottomAnchor.constraint(equalTo: trackScroll.bottomAnchor),
                trackStack.heightAnchor.constraint(equalTo: trackScroll.heightAnchor)
            ])
            
            for (trackIndex, track) in category.tracks.enumerated() {
                let trackButton = MusicTrackButton()
                trackButton.configure(with: track.name, color: UIColor(white: 1, alpha: 0.08), isPlaying: false)
                trackButton.tag = catIndex * 100 + trackIndex
                trackButton.addTarget(self, action: #selector(trackButtonTapped(_:)), for: .touchUpInside)
                trackStack.addArrangedSubview(trackButton)
                NSLayoutConstraint.activate([
                    trackButton.widthAnchor.constraint(equalToConstant: 140),
                    trackButton.heightAnchor.constraint(equalToConstant: 60)
                ])
            }
            
            contentStack.addArrangedSubview(trackScroll)
            trackScroll.heightAnchor.constraint(equalToConstant: 60).isActive = true
        }
        
        contentStack.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
    }
    
    private func addWaveformAnimation() {
        musicWaveformView.subviews.forEach { $0.removeFromSuperview() }
        let numberOfBars = 20
        let barWidth: CGFloat = 3
        let spacing: CGFloat = 3
        let maxHeight: CGFloat = 24
        let totalWidth = CGFloat(numberOfBars) * (barWidth + spacing)
        let barsContainer = UIView()
        barsContainer.translatesAutoresizingMaskIntoConstraints = false
        musicWaveformView.addSubview(barsContainer)
        NSLayoutConstraint.activate([
            barsContainer.centerXAnchor.constraint(equalTo: musicWaveformView.centerXAnchor),
            barsContainer.centerYAnchor.constraint(equalTo: musicWaveformView.centerYAnchor),
            barsContainer.widthAnchor.constraint(equalToConstant: totalWidth),
            barsContainer.heightAnchor.constraint(equalToConstant: maxHeight)
        ])
        
        for i in 0..<numberOfBars {
            let bar = UIView()
            bar.backgroundColor = UIColor(red: 0.0, green: 0.8, blue: 0.4, alpha: 1.0)
            bar.layer.cornerRadius = 1.5
            bar.translatesAutoresizingMaskIntoConstraints = false
            barsContainer.addSubview(bar)
            let height = CGFloat.random(in: 4...maxHeight)
            NSLayoutConstraint.activate([
                bar.centerYAnchor.constraint(equalTo: barsContainer.centerYAnchor),
                bar.leadingAnchor.constraint(equalTo: barsContainer.leadingAnchor, constant: CGFloat(i) * (barWidth + spacing)),
                bar.widthAnchor.constraint(equalToConstant: barWidth),
                bar.heightAnchor.constraint(equalToConstant: height)
            ])
        }
    }
    
    @objc private func backButtonTapped() {
        player?.stop()
        dismiss(animated: true)
    }
    
    @objc private func doneButtonTapped() {
        // Seçili müziği delegate ile ilet
        if let indexPath = currentlyPlayingIndexPath, let url = selectedMusicURL {
            let cat = categories[indexPath.section]
            let track = cat.tracks[indexPath.row]
            delegate?.didSelectMusic(image: selectedImage, title: track.name, url: url)
        } else {
            print("No music selected to pass back")
        }
        player?.stop()
        dismiss(animated: true)
    }
    
    @objc private func trackButtonTapped(_ sender: MusicTrackButton) {
        let tag = sender.tag
        let catIndex = tag / 100
        let trackIndex = tag % 100
        let indexPath = IndexPath(row: trackIndex, section: catIndex)
        
        // Eğer aynı müzik tekrar tıklandıysa durdur
        if let prev = currentlyPlayingIndexPath, prev == indexPath {
            player?.stop()
            sender.setPlaying(false, highlightColor: UIColor(red: 0.0, green: 0.8, blue: 0.4, alpha: 1.0))
            currentlyPlayingIndexPath = nil
            selectedMusicURL = nil
            return
        }
        
        // Önceki çalanı sıfırla
        if let prev = currentlyPlayingIndexPath, let prevButton = view.viewWithTag(prev.section * 100 + prev.row) as? MusicTrackButton {
            prevButton.setPlaying(false, highlightColor: UIColor(red: 0.0, green: 0.8, blue: 0.4, alpha: 1.0))
            player?.stop()
        }
        
        // Seçili butonu güncelle
        sender.setPlaying(true, highlightColor: UIColor(red: 0.0, green: 0.8, blue: 0.4, alpha: 1.0))
        currentlyPlayingIndexPath = indexPath
        
        // Müzik çalma işlemi
        let cat = categories[catIndex]
        let track = cat.tracks[trackIndex]
        if let url = Bundle.main.url(forResource: track.fileName, withExtension: "mp3") {
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.play()
                selectedMusicURL = url
                selectedMusicTitle = track.name
            } catch {
                print("Failed to play music: \(error)")
            }
        }
    }
}

class MusicTrackButton: UIButton {
    private let titleLabelCustom = UILabel()
    private let playIcon = UIImageView()
    private let glowView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 1, alpha: 0.08)
        layer.cornerRadius = 14
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.10
        layer.shadowRadius = 6
        layer.shadowOffset = CGSize(width: 0, height: 2)
        
        titleLabelCustom.font = UIFont(name: "Cousine-Bold", size: 14) ?? .boldSystemFont(ofSize: 14)
        titleLabelCustom.textColor = .white
        titleLabelCustom.numberOfLines = 0
        titleLabelCustom.textAlignment = .left
        titleLabelCustom.translatesAutoresizingMaskIntoConstraints = false
        
        playIcon.image = UIImage(systemName: "play.fill")
        playIcon.tintColor = .white
        playIcon.translatesAutoresizingMaskIntoConstraints = false
        
        glowView.backgroundColor = .clear
        glowView.layer.cornerRadius = 14
        glowView.translatesAutoresizingMaskIntoConstraints = false
        
        glowView.isUserInteractionEnabled = false
        playIcon.isUserInteractionEnabled = false
        titleLabelCustom.isUserInteractionEnabled = false
        
        addSubview(glowView)
        addSubview(playIcon)
        addSubview(titleLabelCustom)
        
        NSLayoutConstraint.activate([
            glowView.topAnchor.constraint(equalTo: topAnchor),
            glowView.leadingAnchor.constraint(equalTo: leadingAnchor),
            glowView.trailingAnchor.constraint(equalTo: trailingAnchor),
            glowView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            playIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            playIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            playIcon.widthAnchor.constraint(equalToConstant: 18),
            playIcon.heightAnchor.constraint(equalToConstant: 22),
            
            titleLabelCustom.leadingAnchor.constraint(equalTo: playIcon.trailingAnchor, constant: 10),
            titleLabelCustom.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            titleLabelCustom.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String, color: UIColor, isPlaying: Bool) {
        titleLabelCustom.text = title
        setPlaying(isPlaying, highlightColor: UIColor(red: 0.0, green: 0.8, blue: 0.4, alpha: 1.0))
    }
    
    func setPlaying(_ playing: Bool, highlightColor: UIColor) {
        if playing {
            layer.borderWidth = 2
            layer.borderColor = highlightColor.cgColor
            glowView.backgroundColor = highlightColor.withAlphaComponent(0.18)
            playIcon.image = UIImage(systemName: "pause.fill")
            backgroundColor = UIColor(red: 0.0, green: 0.8, blue: 0.4, alpha: 0.15)
        } else {
            layer.borderWidth = 0
            layer.borderColor = UIColor.clear.cgColor
            glowView.backgroundColor = .clear
            playIcon.image = UIImage(systemName: "play.fill")
            backgroundColor = UIColor(white: 1, alpha: 0.08)
        }
    }
}
