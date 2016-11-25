# ProgressView

[![Version](https://img.shields.io/github/release/pnicholls/ProgressView.svg)](https://github.com/pnicholls/ProgressView/releases)
![Swift Version](https://img.shields.io/badge/swift-3.0.1-orange.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

ProgressView is a means for displaying a progress indicator for a collection of `Progressable` items.

This is heavily inspired by Instagram Stories. 

## Usage

```swift
extension ExampleViewController: ProgressViewDelegate, ProgressViewDataSource {
    
    // MARK: - ProgressViewDelegate
    
    // MARK: - ProgressViewDataSource
    
    func items(for progressView: ProgressView) -> [Progressable] {
        return items
    }
}

public protocol Progressable {
    var progress: ProgressViewObservable<Double> { set get }
}
```

## Example

![alt tag](https://cloud.githubusercontent.com/assets/139051/20614152/5e91b676-b31f-11e6-95b7-14d903992b6d.PNG)

![alt tag](https://cloud.githubusercontent.com/assets/139051/20614151/5e8e900e-b31f-11e6-904d-5a1dfbcb6db3.PNG)
