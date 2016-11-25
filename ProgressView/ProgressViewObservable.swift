//
//  ProgressViewObservable.swift
//  ProgressView
//
//  Created by Peter Nicholls on 16/11/16.
//  Copyright © 2016 Peter Nicholls. All rights reserved.
//

/*:
 ## Implementation
 Given that the `Observable` object has state/a lifecycle, I decided to make it a class:
 */
public final class ProgressViewObservable<T>: ProgressViewObservableProtocol {
    
    /*:
     We'll start out by defining a variable and a couple of handy types.
     Our model of subscribers is `observers`, a variable array of `ObserversEntry` entries. Each  entry is a tuple composed of a listening object and the block it expects to run upon the `Observable` firing. By passing in this listening object and associating it with the block to execute, we can easily look for it in the `unsubscribe` method to remove it.
     */
    typealias ObserverBlock = (_ newValue: T, _ oldValue: T) -> ()
    typealias ObserversEntry = (observer: AnyObject, block: ObserverBlock)
    private var observers: Array<ObserversEntry>
    
    /*:
     Now we'll need to implement an `init` for our class. The default initializer will simply take an initial value for the observable (declaration forthcoming). Given that we're writing Swift here, we'll need to initialize our non-optional `observers` array as well.
     */
    init(_ value: T) {
        self.value = value
        observers = []
    }
    
    /*:
     At this point, when we construct an `Observable` we'll have an initial value. This value is even assignable, but currently we don't have any way of telling the objects in our `observers` array that the value changed. To do this, we'll implement `didSet` for our `value` variable. All we need to do is loop through our listeners and call their associated blocks. Simple!
     */
    var value: T {
        didSet {
            observers.forEach { (entry: ObserversEntry) in
                let (_, block) = entry
                block(value, oldValue)
            }
        }
    }
    
    /*:
     Last but not least, the mechanism to notify observers is in place, but we have no way to update the `observers` array. We'll implement `subscribe` and `unsubscribe` to package up and add/remove observer tuples into the internal array.
     */
    
    internal func subscribe(observer: AnyObject, block: @escaping (T, T) -> ()) {
        let entry: ObserversEntry = (observer: observer, block: block)
        observers.append(entry)
    }
    
    internal func unsubscribe(observer: AnyObject) {
        let filtered = observers.filter { entry in
            let (owner, _) = entry
            return owner !== observer
        }
        
        observers = filtered
    }
}
