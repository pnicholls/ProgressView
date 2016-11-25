//
//  ProgressViewConfiguration.swift
//  ProgressView
//
//  Created by Peter Nicholls on 16/11/16.
//  Copyright © 2016 Peter Nicholls. All rights reserved.
//

public struct ProgressViewConfiguration {
    
    // MARK: - Properties
    
    let indicatorBackgroundColor: UIColor
    
    let indicatorBackgroundAlpha: Float
    
    let indicatorColor: UIColor
    
    let indicatorAlpha: Float
    
    // MARK: - Initializers
    
    public init(indicatorBackgroundColor: UIColor, indicatorBackgroundAlpha: Float, indicatorColor: UIColor, indicatorAlpha: Float) {
        self.indicatorBackgroundColor = indicatorBackgroundColor
        self.indicatorBackgroundAlpha = indicatorBackgroundAlpha
        self.indicatorColor = indicatorColor
        self.indicatorAlpha = indicatorAlpha
    }
}
