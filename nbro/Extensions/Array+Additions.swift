//
//  Array+Additions.swift
//  nbro
//
//  Created by Casper Storm Larsen on 16/02/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    mutating func removeObject(_ object: Element) {
        if let index = self.index(of: object) {
            self.remove(at: index)
        }
    }
    
    mutating func removeObjectsInArray(_ array: [Element]) {
        for object in array {
            self.removeObject(object)
        }
    }
}

extension Array {
    var shuffle: [Element] {
        var elements = self
        for index in indices {
            let anotherIndex = Int(arc4random_uniform(UInt32(elements.count - index))) + index
            anotherIndex != index ? elements.swapAt(index, anotherIndex) : ()
        }
        return elements
    }
    mutating func shuffled() {
        self = shuffle
    }
    var chooseOne: Element {
        return self[Int(arc4random_uniform(UInt32(count)))]
    }
    func choose(_ n: Int) -> [Element] {
        return Array(shuffle.prefix(n))
    }
}
