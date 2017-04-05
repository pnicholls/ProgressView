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
    
    fileprivate var progressItem: ProgressViewProgressable? {
        didSet {
            guard let progressItem = progressItem else { return }
            
            animate(for: progressItem.progress.value)
            progressItem.progress.subscribe(observer: self, block: { [weak self] newValue, _ in
                self?.animate(for: newValue)
            })
        }
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundLayer.frame = CGRect(x: 5, y: 0, width: frame.size.width - 5, height: frame.size.height)
        backgroundLayer.cornerRadius = backgroundLayer.frame.size.height * 0.50
        
        progressLayer.frame = CGRect(x: backgroundLayer.frame.origin.x, y: backgroundLayer.frame.origin.y, width: backgroundLayer.frame.size.width * CGFloat(progressItem?.progress.value ?? 0.0), height: backgroundLayer.frame.size.height)
        progressLayer.cornerRadius = backgroundLayer.frame.size.height * 0.50
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        progressItem = nil
    }
    
    // MARK: - Functions
    
    func configure(with progressItem: ProgressViewProgressable) {
        self.progressItem = progressItem
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
    
    fileprivate func animate(for progress: Double) {
        // Ensure the progress is valid
        guard !progress.isNaN && progress >= 0 else {
            return
        }
        
        // Update the frame
        progressLayer.frame = CGRect(x: progressLayer.frame.origin.x, y: progressLayer.frame.origin.y, width: backgroundLayer.frame.size.width * CGFloat(progress), height: progressLayer.frame.size.height)
    }
}

