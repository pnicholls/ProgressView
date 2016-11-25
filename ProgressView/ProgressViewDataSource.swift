//
//  ProgressViewDataSource.swift
//  ProgressView
//
//  Created by Peter Nicholls on 16/11/16.
//  Copyright © 2016 Peter Nicholls. All rights reserved.
//

protocol ProgressViewDataSource: class {
    func items(for progressView: ProgressView) -> [Progressable]
}
