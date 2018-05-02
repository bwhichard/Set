//
//  ViewController.swift
//  Set
//
//  Created by Brandon Whichard on 4/6/18.
//  Copyright © 2018 Brandon Whichard. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var gameView: GameView!
    
    private var game = SetGame( SetUI.symbolNames, SetUI.colorNames, SetUI.shadingNames,  SetUI.counts )
    private var selectedCards : [CardView] = []
    private var cardToUICard : [CardView:Card] = [:]
    private var foundSet : [CardView] = []
    private var isThereASet : Bool {return (foundSet.count == SetGameRules.setCount) }
    private var uiCards: [CardView] = []
    @IBOutlet weak var SetLabel: UILabel!
    @IBOutlet weak var DealButton: UIButton!
    @IBOutlet weak var ScoreLabel: UILabel!
    @IBOutlet weak var NewGame: UIButton!
    
    @IBAction func dealthreeCards(_ sender: UIButton) {
        dealThreeCards()
    }
    
    private func dealThreeCards() {
        if (isThereASet) {
            replaceTheSet();
        } else {
            if let newCards = game.dealCards(cardsRequested: SetGameRules.regularDeal) {
                for cardIndex in 0..<newCards.count {
                    let newCard = createCardView(card: newCards[cardIndex])
                    uiCards.append(newCard)
                    cardToUICard[newCard] = newCards[cardIndex]
                    assert( checkUICardMatchesCard(), "ViewController:dealThreeCards Cards don't match")
                }
            } else {
                SetLabel.text = "No More Cards"
            }
        }
        updateModel()
    }
    
    func findOpenSlots() -> [CardView]? {
        return Array(repeating : CardView(), count: 3)
    }
    
    private func replaceTheSet() {
        if let newCards = game.dealCards(cardsRequested: SetGameRules.regularDeal) {
            for cardIndex in 0..<newCards.count {
                decorateCard(card: newCards[cardIndex], uiCard: foundSet[cardIndex])
            }
            SetLabel.text = ""
        } else {
            //_ = foundSet.map( {hideACard(UICard: $0)} )
            for card in foundSet {
                if let indexToRemove = uiCards.index(of: card) {
                    uiCards.remove(at: indexToRemove)
                }
            }
//            foundSet.map( { uiCards.index(where )})
//            SetLabel.text = "No Cards Left"
        }
        foundSet.removeAll()
    }
    
    @IBAction func swipeDownAction(_ sender: UISwipeGestureRecognizer) {
        dealThreeCards()
    }
    
    @IBAction func cardSelectedAction(_ sender: UITapGestureRecognizer) {
        if let uiCard = sender.view as? CardView {
            cardSelected( uiCard )
        } else {
            print("Did not tap on a card")
        }
    }
    
    @IBAction func rotationAction(_ sender: UIRotationGestureRecognizer) {
        shuffleDisplayCards()
    }
    
    func cardSelected(_ sender: CardView) {
        
        // Reset UI if three cards were selected
        if (isThereASet) {
           replaceTheSet()
        } else if (selectedCards.count == SetGameRules.setCount) {
            _ = selectedCards.map( {$0.selected = false} )
            selectedCards.removeAll()
        }
        
        // Highlight the cards
        if (selectedCards.count < SetGameRules.setCount ) {
            if (!selectedCards.contains(sender)) {
                sender.selected = true
                selectedCards.append(sender)
            } else {
                sender.selected = false
                if let index = selectedCards.index(of: sender) {
                    selectedCards.remove( at: index )
                }
            }
        }
        
        // Determine if there was a set
        if ( selectedCards.count == SetGameRules.setCount) {
            let threeCards = selectedCards.map( {cardToUICard[$0]} )
            if (threeCards.count == SetGameRules.setCount ) {
                let isSet = game.threeCardsSelected(threeCards[0]!, threeCards[1]!, threeCards[2]!)
                if (isSet) {
                    _ = selectedCards.map( {$0.layer.backgroundColor = SetUI.foundSetBackgroundUIColor} )
                    foundSet = selectedCards
                    selectedCards.removeAll()
                    SetLabel.text = "Found Set!"
                } else {
                    SetLabel.text = "No Set"
                }
            }
        }
        updateModel()
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        newGame()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCardButtons()
        updateModel()
    }
    
    
    private func newGame() {
        game = SetGame( SetUI.symbolNames, SetUI.colorNames, SetUI.shadingNames,  SetUI.counts )
        setUpCardButtons()
        SetLabel.text = ""
        updateModel()
    }
    
    private func updateModel() {
        ScoreLabel.text = "Score: \(game.score)"
        if ((findOpenSlots() == nil || game.cardsInDeck < SetGameRules.regularDeal ) && !isThereASet)  {
            DealButton.isEnabled = false
        } else {
            DealButton.isEnabled = true
        }
        gameView.cards = uiCards
        assert( checkUICardMatchesCard(), "ViewController:UpdateModel Cards don't match")
    }
    
    private func setUpCardButtons() {
        SetLabel.text = ""
        
        selectedCards.removeAll()
        cardToUICard.removeAll()
        
        let cards = game.dealCards(cardsRequested: SetGameRules.firstDeal)!
        uiCards.removeAll()
        
        for index in 0..<SetGameRules.firstDeal {
            //let cardView = decorateCard(card: cards[index], uiCard: uiCards[index] )
            let cardView = createCardView(card: cards[index])
            uiCards.append(cardView)
            cardToUICard[uiCards[index]] = cards[index]
        }

        
        gameView.cards = uiCards
        assert( checkUICardMatchesCard(), "ViewController:setUpCardButtons Cards don't match")
    }
    
    private func hideACard(UICard : CardView) {
        cardToUICard.removeValue(forKey: UICard)
    }
    
    private func decorateCard(card : Card, uiCard : CardView ) {
        uiCard.color = SetUI.colorDictionary[card.color]!
        uiCard.symbol = card.symbol
        uiCard.shading = card.shading
        uiCard.symbolCount = SetUI.countDictionary[card.count]!
        uiCard.selected = false

        cardToUICard[uiCard] = card
    }
    
    private func createCardView(card : Card ) -> CardView {
        let newCardView = CardView()
        newCardView.color = SetUI.colorDictionary[card.color]!
        newCardView.symbol = card.symbol
        newCardView.shading = card.shading
        newCardView.symbolCount = SetUI.countDictionary[card.count]!
        
        let tap = UITapGestureRecognizer(target: self, action: #selector( cardSelectedAction ) )
        newCardView.addGestureRecognizer( tap )
        
        return newCardView
    }
    
    func checkUICardMatchesCard() -> Bool {
        for (uiCard, card) in cardToUICard {
            if ( card != uiCard) {
                return false
            }
        }
        return true
    }
    
    func doesCardMatchUICard(card : Card, uiCard : CardView) -> Bool {
        return (
            uiCard.color == SetUI.colorDictionary[card.color]! &&
            uiCard.symbol == card.symbol &&
            uiCard.shading == card.shading &&
            uiCard.symbolCount == SetUI.countDictionary[card.count]!)
    }
    
    func shuffleDisplayCards() {
        let numberOfCards = uiCards.count
        for index in 0..<numberOfCards {
            let randomIndex = numberOfCards.getRandomInt()
            let swapCard = uiCards[index]
            uiCards[index] = uiCards[randomIndex]
            uiCards[randomIndex] = swapCard
        }
        updateModel()
    }
}

extension Card {
    var attributedString : NSAttributedString {
        let cardSymbol = SetUI.symbolDictionary[self.symbol]!
        let howManySymbols = SetUI.countDictionary[self.count]!
        let symbolForCard = String(repeating : cardSymbol, count : howManySymbols)
        
        var UIColorForCard = SetUI.colorDictionary[self.color]!
        let shadingNumber = SetUI.shadingDictionary[self.shading]!
        
        if (self.shading == SetUI.striped ) {
            UIColorForCard = UIColorForCard.withAlphaComponent( SetUI.alpha  )
        }
        
        let attributes : [NSAttributedStringKey : Any] = [
            .strokeColor : UIColorForCard,
            .strokeWidth : shadingNumber,
            .foregroundColor : UIColorForCard,
            .font : UIFont.systemFont(ofSize: SetUI.fontSize)]
    
        return NSAttributedString(string : symbolForCard, attributes : attributes)
    }
    
    static func ==(card : Card, uiCard : UIButton) -> Bool {
        return card.attributedString == uiCard.currentAttributedTitle
    }
    
    static func !=(card : Card, uiCard : UIButton) -> Bool {
        return !(card == uiCard)
    }
    
    static func ==(card : Card, uiCard : CardView ) -> Bool {
        return (
            uiCard.color == SetUI.colorDictionary[card.color]! &&
                uiCard.symbol == card.symbol &&
                uiCard.shading == card.shading &&
                uiCard.symbolCount == SetUI.countDictionary[card.count]!)
    }
    
    static func !=(card : Card, uiCard : CardView ) -> Bool {
        return !(card == uiCard)
    }
}

extension UIButton {
    var isCardHidden : Bool {
        return (self.backgroundColor == SetUI.hiddenCardUIColor)
    }
}

extension Int {
    func getRandomInt() -> Int {
        let maxValueUInt32 = UInt32(self)
        let randomInt = Int(arc4random_uniform(maxValueUInt32))
        return randomInt
    }
}


