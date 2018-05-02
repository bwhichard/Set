//
//  GameView.swift
//  Set
//
//  Created by Brandon Whichard on 4/26/18.
//  Copyright © 2018 Brandon Whichard. All rights reserved.
//

import UIKit


class GameView: UIView {

    private static let insetValue = CGFloat (2.0)
    private static let aspectRatio = Grid.Layout.aspectRatio(3/5)
    private static let inset = UIEdgeInsets(top: insetValue, left: insetValue, bottom: insetValue, right: insetValue)
    
    var cards : [CardView] = [] { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var grid = Grid(layout: GameView.aspectRatio)
    
    override func draw(_ rect: CGRect) {
        let formatRec = UIBezierPath(rect: bounds)
        UIColor.black.setFill()
        formatRec.fill()
        removeSubViews()
        addCardsToGrid()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        grid.frame = bounds
        addCardsToGrid()
    }
    
    private func removeSubViews() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
    
    private func addCardsToGrid() {
        grid.frame = bounds
        grid.cellCount = cards.count
        for index in 0..<cards.count {
            cards[index].frame = UIEdgeInsetsInsetRect(grid[index]!, GameView.inset)
            addSubview(cards[index])
        }
    }
}
