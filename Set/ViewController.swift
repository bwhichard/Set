//
//  ViewController.swift
//  Set
//
//  Created by Brandon Whichard on 4/6/18.
//  Copyright © 2018 Brandon Whichard. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var game = SetGame( SetUI.symbolNames, SetUI.colorNames, SetUI.shadingNames,  SetUI.counts )
    private var selectedCards : [UIButton] = []
    private var cardToUICard : [UIButton:Card] = [:]
    private var foundSet : [UIButton] = []
    private var isThereASet : Bool {return (foundSet.count == SetGameRules.setCount) }

    @IBOutlet var UIButtons: [UIButton]!
    @IBOutlet weak var SetLabel: UILabel!
    @IBOutlet weak var DealButton: UIButton!
    @IBOutlet weak var ScoreLabel: UILabel!
    
    @IBAction func dealthreeCards(_ sender: UIButton) {
        if (isThereASet) {
            replaceTheSet();
        } else if let openSlots = findOpenSlots() {
            if let newCards = game.dealCards(cardsRequested: SetGameRules.regularDeal) {
                for cardIndex in 0..<openSlots.count {
                    decorateButoon(card: newCards[cardIndex], UICard: openSlots[cardIndex])
                    cardToUICard[openSlots[cardIndex]] = newCards[cardIndex]
                    assert( checkUICardMatchesCard(), "ViewController:dealThreeCards Cards don't match")
                }
            } else {
                SetLabel.text = "No More Cards"
            }
        } else {
            SetLabel.text = "Board Full"
        }
        updateModel()
    }
    
    func findOpenSlots() -> [UIButton]? {
        var emptyUISlots : [UIButton]? = []

        for uiCardIndex in 0..<UIButtons.count  {
            if (UIButtons[uiCardIndex].backgroundColor == SetUI.hiddenCardUIColor) {
                emptyUISlots?.append(UIButtons[uiCardIndex])
            }
            if emptyUISlots?.count == SetGameRules.regularDeal {
                return emptyUISlots
            }
        }
        return nil
    }
    
    private func replaceTheSet() {
        if let newCards = game.dealCards(cardsRequested: SetGameRules.regularDeal) {
            for cardIndex in 0..<newCards.count {
                decorateButoon(card: newCards[cardIndex], UICard: foundSet[cardIndex])
            }
            SetLabel.text = ""
        } else {
            _ = foundSet.map( {hideACard(UICard: $0)} )
            SetLabel.text = "No Cards Left"
        }
        foundSet.removeAll()
    }
    
    @IBAction func UIButtonClick(_ sender: UIButton) {
        if (!sender.isCardHidden) {
            
            // Reset UI if three cards were selected
            if (isThereASet) {
               replaceTheSet()
            } else if (selectedCards.count == SetGameRules.setCount) {
                _ = selectedCards.map( {$0.layer.borderColor = SetUI.cardBorderColor} )
                selectedCards.removeAll()
            }
            
            // Highlight the cards
            if (selectedCards.count < SetGameRules.setCount ) {
                if (!selectedCards.contains(sender)) {
                    sender.layer.borderColor = SetUI.selectedCardBorderColor
                    selectedCards.append(sender)
                    SetLabel.text = ""
                } else {
                    sender.layer.borderColor = SetUI.cardBorderColor
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
        assert( checkUICardMatchesCard(), "ViewController:UpdateModel Cards don't match")
    }
    
    private func setUpCardButtons() {
        SetLabel.text = ""
        selectedCards.removeAll()
        cardToUICard.removeAll()
        
        let cards = game.dealCards(cardsRequested: SetGameRules.firstDeal)!
        
        for cardIndex in 0..<SetGameRules.firstDeal {
            decorateButoon(card: cards[cardIndex], UICard: UIButtons[cardIndex])
            cardToUICard[UIButtons[cardIndex]] = cards[cardIndex]
        }
        
        for hideCardIndex in (SetGameRules.firstDeal..<SetGameRules.totalDeal) {
            hideACard(UICard : UIButtons[hideCardIndex])
        }
        assert( checkUICardMatchesCard(), "ViewController:setUpCardButtons Cards don't match")
    }
    
    private func hideACard(UICard : UIButton) {
        UICard.setTitle("", for: UIControlState.normal)
        UICard.backgroundColor = SetUI.hiddenCardUIColor
        UICard.layer.borderColor = SetUI.hiddenCardBorderCGColor
        UICard.setAttributedTitle(nil, for: UIControlState.normal)
        cardToUICard.removeValue(forKey: UICard)
    }
    
    private func decorateButoon(card : Card, UICard : UIButton ) {
        UICard.layer.borderWidth = SetUI.cardBorderWidth
        UICard.layer.borderColor = SetUI.cardBorderColor
        UICard.layer.cornerRadius = SetUI.cardCornerRaduis
        UICard.layer.backgroundColor = SetUI.cardBackgroundUIColor
        
        let UICardTitle = card.attributedString
        UICard.setAttributedTitle(UICardTitle, for: UIControlState.normal)
        cardToUICard[UICard] = card
    }
    
    func checkUICardMatchesCard() -> Bool {
        for (uiCard, card) in cardToUICard {
            if ( card != uiCard) {
                print ("Cards don't match \(card) vs. \(uiCard.attributedTitle(for: UIControlState.normal)!)")
                return false
            }
        }
        return true
    }
    
    func doesCardMatchUICard(card : Card, uiCard : UIButton) -> Bool {
        return ( card.attributedString == uiCard.currentAttributedTitle )
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
}

extension UIButton {
    var isCardHidden : Bool {
        return (self.backgroundColor == SetUI.hiddenCardUIColor)
    }
}


