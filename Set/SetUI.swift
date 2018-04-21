//
//  SetUI.swift
//  Set
//
//  Created by Brandon Whichard on 4/20/18.
//  Copyright © 2018 Brandon Whichard. All rights reserved.
//

import Foundation
import UIKit

struct SetUI {
    static let symbolNames = ["diamond", "squiggle", "oval"]
    static let cardSymbols = ["▲","●", "■"]
    static let symbolDictionary = Dictionary( uniqueKeysWithValues: zip(symbolNames, cardSymbols) )
    
    static let colorNames = ["red", "green", "purple"]
    static let cardColors = [UIColor.red, UIColor.green, UIColor.purple]
    static let colorDictionary = Dictionary( uniqueKeysWithValues: zip(colorNames, cardColors) )
    
    static let shadingNames = ["solid", "striped", "open"]
    static let cardShading = [-5, 0, 5 ]
    static let shadingDictionary = Dictionary( uniqueKeysWithValues: zip(shadingNames, cardShading) )
    
    static let counts = ["1","2","3"]
    static let countValues = [1,2,3]
    static let countDictionary = Dictionary( uniqueKeysWithValues: zip(counts, countValues) )
    
    static let alpha : CGFloat = 0.15
    static let fontSize = CGFloat(18.0)
    static let hiddenCardUIColor : UIColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0)
    static let hiddenCardBorderCGColor : CGColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0)
    static let cardBorderWidth : CGFloat = 3.0
    static let cardCornerRaduis : CGFloat = 8.0
    static let cardBorderColor = UIColor.gray.cgColor
    static let cardBackgroundUIColor = UIColor.lightGray.cgColor
    static let selectedCardBorderColor = UIColor.blue.cgColor
    static let foundSetBackgroundUIColor = UIColor.yellow.cgColor
    static let striped = shadingNames[1]
}

struct SetGameRules {
    static let firstDeal = 12
    static let totalDeal = 24
    static let regularDeal = 3
    static let setCount = 3
}
