//
//  MainCanvasListViewController.swift
//  chatcanvas
//
//  Created by Müge Deniz on 23.04.2025.
//

import UIKit
import Alamofire
import SDWebImage

class MainCanvasListViewController: UIViewController, WholeCanvasTableViewCellDelegate {
    @IBOutlet weak var wholeTableView: UITableView!
    private var backgroundData: BackgroundModel?
    private var premiumView: PremiumView?
    private var customTabBar: CustomTabBarView!
    
    private let reachabilityManager = NetworkReachabilityManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setTableView()
        setupTabBar()
        setupLanguageObserver()
        checkInternetAndFetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        checkInternetAndFetchData()
        customTabBar.updateSelectedButton(tag: 0)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }
        
    private func setupTabBar() {
        customTabBar = CustomTabBarView()
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customTabBar)
        
        NSLayoutConstraint.activate([
            customTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            customTabBar.heightAnchor.constraint(equalToConstant: 90) // Increased height for better visuals
        ])
        
        customTabBar.onButtonTapped = { [weak self] tag in
            self?.handleTabBarTap(tag: tag)
        }
        
        // Adjust table view to account for tab bar
        wholeTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        wholeTableView.scrollIndicatorInsets = wholeTableView.contentInset
    }

    private func handleTabBarTap(tag: Int) {
        customTabBar.updateSelectedButton(tag: tag) // Force-update selection
        
        switch tag {
        case 0:
            break // Already on main
        case 1:
            let hashtagVC = HashtagViewController()
            hashtagVC.modalPresentationStyle = .fullScreen
            hashtagVC.onDismiss = { [weak self] in
                self?.customTabBar.updateSelectedButton(tag: 0) 
            }
            present(hashtagVC, animated: true)
        case 2:
            let storyVC = StoryMakerViewController()
            storyVC.modalPresentationStyle = .fullScreen
            storyVC.onDismiss = { [weak self] in
                self?.customTabBar.updateSelectedButton(tag: 0) // Reset on dismiss
            }
            present(storyVC, animated: true)
        default:
            break
        }
    }
    
    private func setupLanguageObserver() {
        NotificationCenter.default.addObserver(self,
                                          selector: #selector(handleLanguageChange),
                                          name: .languageDidChange,
                                          object: nil)
    }
    
    @objc private func handleLanguageChange() {
        print("Language changed to: \(LanguageHelper.currentLanguage)")
        CacheManager.shared.clearBackgroundData()
        checkInternetAndFetchData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func checkInternetAndFetchData() {
        if let isReachable = reachabilityManager?.isReachable, isReachable {
            fetchData()
        } else {
            showNoInternetAlert()
        }
    }
    
    private func fetchData() {
        CacheManager.shared.clearBackgroundData()
        NetworkCaller.shared.fetchBackgroundData { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self?.backgroundData = data
                    self?.wholeTableView.reloadData()
                case .failure:
                    let alertTitle = NSLocalizedString("Error", comment: "")
                    let alertMessage = NSLocalizedString("Failed to load data", comment: "")
                    let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
    
    private func showNoInternetAlert() {
        let alertTitle = NSLocalizedString("No Internet Connection", comment: "")
        let alertMessage = NSLocalizedString("Please check your internet connection and try again.", comment: "")
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.checkInternetAndFetchData()
        })
        present(alert, animated: true)
    }
    
    private func setTableView() {
        wholeTableView.translatesAutoresizingMaskIntoConstraints = false
        wholeTableView.delegate = self
        wholeTableView.dataSource = self
        wholeTableView.register(WholeCanvasTableViewCell.self, forCellReuseIdentifier: "WholeCanvasTableViewCell")
        wholeTableView.separatorStyle = .none
        wholeTableView.backgroundColor = .black
        
        NSLayoutConstraint.activate([
            wholeTableView.topAnchor.constraint(equalTo: view.topAnchor),
            wholeTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wholeTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            wholeTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    func didSelectCategory(_ category: BackgroundCategory) {
        if !category.premium || GlobalHelper.isPremiumActive() {
            navigateToCategory(category)
        } else {
            showPremiumView()
        }
    }
    
    private func showPremiumView() {
        guard premiumView == nil else { return }
        
        let premiumView = PremiumView(frame: view.bounds)
        premiumView.alpha = 0
        premiumView.onDismiss = { [weak self] in
            UIView.animate(withDuration: 0.3) {
                self?.premiumView?.alpha = 0
            } completion: { _ in
                self?.premiumView?.removeFromSuperview()
                self?.premiumView = nil
            }
        }
        view.addSubview(premiumView)
        self.premiumView = premiumView
        
        UIView.animate(withDuration: 0.3) {
            premiumView.alpha = 1
        }
    }
    
    private func navigateToCategory(_ category: BackgroundCategory) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let destinationVC = storyboard.instantiateViewController(withIdentifier: "CatagoriesTenCanvasViewController") as? CatagoriesTenCanvasViewController {
            destinationVC.selectedCategory = category
            navigationController?.pushViewController(destinationVC, animated: true)
        }
    }
}

extension MainCanvasListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WholeCanvasTableViewCell", for: indexPath) as? WholeCanvasTableViewCell else {
            return UITableViewCell()
        }
        
        if let data = backgroundData {
            let localizedData = BackgroundModel(response: data.response, translations: data.translations)
            cell.configure(with: localizedData)
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
