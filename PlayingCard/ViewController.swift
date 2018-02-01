//
//  ViewController.swift
//  PlayingCard
//
//  Created by MonsterHulk on 2018-01-26.
//  Copyright © 2018 AmazingEric. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var deck = PlayingCardDeck()
    
//    @IBOutlet weak var playingCardView: PlayingCardView! {
//        didSet {
//            let swipe = UISwipeGestureRecognizer(target:self, action: #selector(nextCard))
//            swipe.direction = [.left,.right]
//            playingCardView.addGestureRecognizer(swipe)
//            let pinch = UIPinchGestureRecognizer(target: playingCardView, action: #selector(PlayingCardView.adjustFaceCardScale(byHandlingGestureRecognizedBy:)))
//            playingCardView.addGestureRecognizer(pinch)
//        }
//    }
//
//    @IBAction func flipCard(_ sender: UITapGestureRecognizer) {
//        switch sender.state {
//        case .ended:
//            playingCardView.isFaceUp = !playingCardView.isFaceUp
//        default: break
//        }
//    }
//
//
//    @objc func nextCard() {
//        if let card = deck.draw() {
//            playingCardView.rank = card.rank.order
//            playingCardView.suit = card.suit.rawValue
//        }
//    }
    
    @IBOutlet private var cardViews: [PlayingCardView]!

    override func viewDidLoad() {
        super.viewDidLoad()
        var cards = [PlayingCard]()
        for _ in 1...((cardViews.count+1)/2) {
            let card = deck.draw()!
            cards += [card, card]
        }
        for cardView in cardViews {
            cardView.isFaceUp = true
            let card = cards.remove(at: cards.count.arc4random)
            cardView.rank = card.rank.order
            cardView.suit = card.suit.rawValue
        }
    }
}

