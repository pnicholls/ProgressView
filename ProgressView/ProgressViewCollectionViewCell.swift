//
//  ProgressViewCollectionViewCell.swift
//  ProgressView
//
//  Created by Peter Nicholls on 16/11/16.
//  Copyright © 2016 Peter Nicholls. All rights reserved.
//

import UIKit

final class ProgressCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    fileprivate lazy var backgroundLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.backgroundColor = self.tintColor.cgColor
        shapeLayer.opacity = 0.3
        return shapeLayer
    }()
    
    fileprivate lazy var progressLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.backgroundColor = self.tintColor.cgColor
        shapeLayer.opacity = 0.7
        return shapeLayer
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        activateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundLayer.frame = CGRect(x: 5, y: 0, width: frame.size.width - 5, height: frame.size.height)
        backgroundLayer.cornerRadius = backgroundLayer.frame.size.height * 0.50
        
        progressLayer.frame = CGRect(x: backgroundLayer.frame.origin.x, y: 0, width: 0, height: frame.size.height)
        progressLayer.cornerRadius = backgroundLayer.frame.size.height * 0.50
    }
    
    // MARK: - Functions
    
    func configure(with progressItem: Progressable) {
        animate(for: progressItem.progress.value)
        
        progressItem.progress.subscribe(observer: self, block: { [weak self] newValue, _ in
            self?.animate(for: newValue)
        })
    }
    
    func configure(with configuration: ProgressViewConfiguration) {
        backgroundLayer.backgroundColor = configuration.indicatorBackgroundColor.cgColor
        backgroundLayer.opacity = configuration.indicatorBackgroundAlpha
        progressLayer.backgroundColor = configuration.indicatorColor.cgColor
        progressLayer.opacity = configuration.indicatorAlpha
    }
    
    fileprivate func configure() {
        backgroundColor = .clear
        
        contentView.layer.addSublayer(backgroundLayer)
        contentView.layer.addSublayer(progressLayer)
    }
    
    fileprivate func activateConstraints() {
    }
    
    fileprivate func animate(for progress: Double) {
        progressLayer.frame = CGRect(x: progressLayer.frame.origin.x, y: progressLayer.frame.origin.y, width: backgroundLayer.frame.size.width * CGFloat(progress), height: progressLayer.frame.size.height)
    }
}

