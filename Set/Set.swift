//
//  Set.swift
//  Set
//
//  Created by Brandon Whichard on 4/6/18.
//  Copyright © 2018 Brandon Whichard. All rights reserved.
//

import Foundation

class SetGame {

    private(set) var deckOfCards : [Card] = []
    private(set) var foundSets : Dictionary<Int, [Card]> = [:]
    private(set) var missedSetsCount = 0
    var numberOfSetsFound : Int { get { return foundSets.count } }
    var cardsInDeck : Int { get {return deckOfCards.count} }
    var score : Int { get { return ((numberOfSetsFound * 3) - (missedSetsCount * 5)) } }
    
    init(_ symbols : [String], _ colors : [String], _ shadings :[String],_ symbolCounts : [String]) {
        for symbolIndex in 0..<symbols.count {
            for colorIndex in 0..<colors.count {
                for shadingIndex in 0..<shadings.count {
                    for symbolCountIndex in 0..<symbolCounts.count {
                        let newCard = Card(
                            symbol : symbols[symbolIndex],
                            color : colors[colorIndex],
                            shading : shadings[shadingIndex],
                            number : symbolCounts[symbolCountIndex])
                        deckOfCards.append(newCard)
                    }
                }
            }
        }
    shuffleCards()
    }
    
    func threeCardsSelected(_ firstCard:Card, _ secondCard:Card, _ thirdCard: Card) -> Bool {
        let isSet = (
            checkForSet(cardAttribute1: firstCard.symbol, cardAttribute2: secondCard.symbol, cardAttribute3: thirdCard.symbol) &&
            checkForSet(cardAttribute1: firstCard.color, cardAttribute2: secondCard.color, cardAttribute3: thirdCard.color) &&
            checkForSet(cardAttribute1: firstCard.count, cardAttribute2: secondCard.count, cardAttribute3: thirdCard.count) &&
            checkForSet(cardAttribute1: firstCard.shading, cardAttribute2: secondCard.shading, cardAttribute3: thirdCard.shading) )
        
        if isSet {
            let newSet = [firstCard, secondCard, thirdCard]
            foundSets[numberOfSetsFound] = newSet
        } else {
            missedSetsCount += 1
        }
        return isSet
    }
    
    func checkForSet(cardAttribute1 firstStr:String, cardAttribute2 secondStr : String, cardAttribute3 thirdStr: String) -> Bool {
        var foundSet = false
        
        foundSet = (firstStr == secondStr && firstStr == thirdStr)  ||
            (firstStr != secondStr && firstStr != thirdStr && secondStr != thirdStr)
        
        return foundSet
    }
    
    func dealCards ( cardsRequested cards : Int ) -> [Card]? {
        var newCards : [Card]? = nil
        
        if ( cards <= deckOfCards.count ) {
            newCards = Array<Card>( deckOfCards.prefix(cards) )
            deckOfCards.removeFirst(cards)
        }
        return newCards
    }
    
    private func shuffleCards() {
        assert(checkDeckforDups(), "SetGame: ShuffleCards func - Dups before shuffle")
        
        for index in 0..<deckOfCards.count {
            let randomNumber = getRandomInt(notLargerThan: deckOfCards.count)
            let  swapCard = deckOfCards[index]
            deckOfCards[index] = deckOfCards[randomNumber]
            deckOfCards[randomNumber] = swapCard
        }
        
        assert(checkDeckforDups(), "SetGame: ShuffleCards func - Dups after shuffle")
    }
    
    func getRandomInt(notLargerThan maxValue: Int) -> Int {
        let maxValueUInt32 = UInt32(maxValue)
        let randomInt = Int(arc4random_uniform(maxValueUInt32))
        return randomInt
    }
    
    func checkDeckforDups() -> Bool {
        return (checkDeckforDupsDetails() == "No Dups")
    }
    
    func checkDeckforDupsDetails() -> String {
        var message  = ""
        
        for index in 0..<deckOfCards.count {
            if (deckOfCards.index(of: deckOfCards[index]) != index) {
                message.append("Duplicate Card: \(deckOfCards[index])\n")
            }
        }
        
        if (message == "") {
            message = "No Dups"
        }
        return message
    }
}

extension SetGame : CustomStringConvertible {
    var description : String {
        var message = "Deck Count \(deckOfCards.count)\n"
        for card in deckOfCards {
            if let cardIndex = deckOfCards.index(of: card) {
                if ((cardIndex % 3) == 0 ) {
                    message.append("\n")
                }
            message.append("\(cardIndex)\t|\(card)|\t\t\t")
            }
        }
        
        message.append("\n Sets Found: \(numberOfSetsFound)" )
        return message
        }
    }
