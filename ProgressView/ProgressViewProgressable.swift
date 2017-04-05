//
//  ProgressViewProgressable.swift
//  ProgressView
//
//  Created by Peter Nicholls on 16/11/16.
//  Copyright © 2016 Peter Nicholls. All rights reserved.
//

public protocol ProgressViewProgressable {
    var identifier: String { get }
    var progress: ProgressViewObservable<Double> { set get }
}
