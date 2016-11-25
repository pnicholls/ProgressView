//
//  ProgressView.swift
//  ProgressView
//
//  Created by Peter Nicholls on 16/11/16.
//  Copyright © 2016 Peter Nicholls. All rights reserved.
//

import UIKit

public class ProgressView: UIView {
    
    // MARK: - Properties
    
    weak var dataSource: ProgressViewDataSource?
    
    var configuration: ProgressViewConfiguration? = nil {
        didSet {
            reload()
        }
    }
    
    fileprivate lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.minimumInteritemSpacing = 0
        return collectionViewFlowLayout
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewFlowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: ProgressCollectionViewCell.self))
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    fileprivate var items: [Progressable] = []
    
    // MARK: - Initializers
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        activateConstraints()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func reload() {
        collectionView.reloadData()
    }
    
    fileprivate func configure() {
        backgroundColor = .clear
        
        addSubview(collectionView)
    }
    
    fileprivate func activateConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    fileprivate func set(items: [Progressable]) {
        self.items = items
    }
}

extension ProgressView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let items = CGFloat(collectionView.numberOfItems(inSection: indexPath.section))
        
        return CGSize(width: collectionView.frame.size.width / items, height: collectionView.frame.size.height)
    }
    
    // MARK: - UICollectionViewDataSource
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let dataSource = dataSource else {
            return 0
        }
        
        set(items: dataSource.items(for: self))
        
        return items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProgressCollectionViewCell.self), for: indexPath) as! ProgressCollectionViewCell
        cell.configure(with: items[indexPath.row])
        if let configuration = configuration {
            cell.configure(with: configuration)
        }
        
        return cell
    }
}
