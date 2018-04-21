//
//  Card.swift
//  Set
//
//  Created by Brandon Whichard on 4/6/18.
//  Copyright © 2018 Brandon Whichard. All rights reserved.
//

import Foundation

struct Card {
    
    private(set) var symbol = ""
    private(set) var color = ""
    private(set) var count = ""
    private(set) var shading = ""
    
    init (symbol:String, color:String, shading:String, number:String ) {
        self.color = color
        self.symbol = symbol
        self.count = number
        self.shading = shading
    }
}

extension Card : Equatable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        return
            lhs.color == rhs.color &&
            lhs.count == rhs.count &&
            lhs.shading == rhs.shading &&
            lhs.symbol == rhs.symbol
    }
}

extension Card: CustomStringConvertible {
    var description: String {
        return ("\(symbol) \(color) \(shading) \(count)" )
    }
}
