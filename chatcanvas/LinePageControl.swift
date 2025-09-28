//
//  LinePageControl.swift
//  chatcanvas
//
//  Created by Müge Deniz on 24.04.2025.
//

import Foundation
import UIKit

class LinePageControl: UIView {
    private var lineViews: [UIView] = []
    private let lineHeight: CGFloat = 4
    private let lineSpacing: CGFloat = 8
    private let inactiveColor = UIColor(red: 1.0, green: 0.8, blue: 0.9, alpha: 1.0) // Light pink
    private let activeColor = UIColor.white
    private let inactiveWidth: CGFloat = 20
    private let activeWidth: CGFloat = 30
    
    var numberOfPages: Int = 0 {
        didSet {
            setupLines()
        }
    }
    
    var currentPage: Int = 0 {
        didSet {
            updateLines()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = UIColor(red: 0.8, green: 0.2, blue: 0.5, alpha: 0.8) // Magenta background with opacity
        layer.cornerRadius = 4
    }
    
    private func setupLines() {
        lineViews.forEach { $0.removeFromSuperview() }
        lineViews.removeAll()
        
        for i in 0..<numberOfPages {
            let line = UIView()
            line.backgroundColor = (i == currentPage) ? activeColor : inactiveColor
            line.translatesAutoresizingMaskIntoConstraints = false
            addSubview(line)
            lineViews.append(line)
            
            // Set height and width
            line.heightAnchor.constraint(equalToConstant: lineHeight).isActive = true
            line.widthAnchor.constraint(equalToConstant: (i == currentPage) ? activeWidth : inactiveWidth).isActive = true
            
            // Position lines
            if i == 0 {
                line.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
            } else {
                line.leadingAnchor.constraint(equalTo: lineViews[i - 1].trailingAnchor, constant: lineSpacing).isActive = true
            }
            line.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }
        
        if let lastLine = lineViews.last {
            lastLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        }
    }
    
    private func updateLines() {
        for (index, line) in lineViews.enumerated() {
            let isActive = index == currentPage
            let targetWidth: CGFloat = isActive ? activeWidth : inactiveWidth
            let targetColor = isActive ? activeColor : inactiveColor
            
            // Animate the line width and color
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                line.backgroundColor = targetColor
                line.constraints.forEach { constraint in
                    if constraint.firstAttribute == .width {
                        constraint.constant = targetWidth
                    }
                }
                self.layoutIfNeeded()
            }
        }
    }
}
