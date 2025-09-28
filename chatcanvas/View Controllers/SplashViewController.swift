//
//  SplashViewController.swift
//  chatcanvas
//
//  Created by Müge Deniz on 23.04.2025.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigateToMain()
    }
    
    func navigateToMain() {
        GlobalHelper.pushController(id: "MainCanvasListViewController", self) { (vc: MainCanvasListViewController) in
        }
    }
}
