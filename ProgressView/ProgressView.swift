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
    
    public weak var dataSource: ProgressViewDataSource?
    
    public var configuration: ProgressViewConfiguration? = nil {
        didSet {
            reloadData()
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
    
    fileprivate var items: [ProgressViewProgressable] = [] {
        didSet {
            bind(to: items)
        }
    }
    
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
    
    public func reloadData() {
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
    
    fileprivate func set(items: [ProgressViewProgressable]) {
        self.items = items
    }
    
    fileprivate func bind(to items: [ProgressViewProgressable]) {
        items.forEach { [weak self] (item) in
            self?.bind(to: item)
        }
    }
    
    fileprivate func bind(to item: ProgressViewProgressable) {
        item.progress.subscribe(observer: self, block: { [weak self] (newValue, previousValue) in
            guard let items = self?.items, let index = items.index(where: { $0.identifier == item.identifier }) else {
                return
            }
            
            let itemsBefore = items[0..<index]
            itemsBefore.forEach { $0.progress.value = 1.0 }
        })
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
