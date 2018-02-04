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
    
    //3 steps: Animator, Behaviours, Items
    lazy var animator = UIDynamicAnimator(referenceView: view)
    
    lazy var cardBehaviour = CardBehaviour(in: animator)

    override func viewDidLoad() {
        super.viewDidLoad()
        var cards = [PlayingCard]()
        for _ in 1...((cardViews.count+1)/2) {
            let card = deck.draw()!
            cards += [card, card]
        }
        for cardView in cardViews {
            cardView.isFaceUp = false
            let card = cards.remove(at: cards.count.arc4random)
            cardView.rank = card.rank.order
            cardView.suit = card.suit.rawValue
            cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCard(_:))))  //put name(only external name of arguements) of the method inside selector,   _: : no external name
//            collisionBehaviour.addItem(cardView)
//            itemBehaviour.addItem(cardView)
            cardBehaviour.addItem(cardView)
        }
    }
    
    private var faceUpCardViews: [PlayingCardView] {
        return cardViews.filter { $0.isFaceUp && !$0.isHidden && $0.transform != CGAffineTransform.identity.scaledBy(x: 1.25, y: 1.25) && $0.alpha == 1
        }
    }
    
    private var faceUpCardViewsMatch: Bool {
        return faceUpCardViews.count == 2 &&
        faceUpCardViews[0].rank == faceUpCardViews[1].rank &&
        faceUpCardViews[0].suit == faceUpCardViews[1].suit
    }
    
    var lastChosenCardView: PlayingCardView?  //nil when start the game
    
    @objc func flipCard(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            if let chosenCardView = recognizer.view as? PlayingCardView, faceUpCardViews.count < 2 {
                lastChosenCardView = chosenCardView
                cardBehaviour.removeItem(chosenCardView)
                UIView.transition(with: chosenCardView, duration: 0.6, options: [.transitionFlipFromLeft], animations: {
                    chosenCardView.isFaceUp = !chosenCardView.isFaceUp
                }, completion: { finished in
                    let cardsToAnimate = self.faceUpCardViews
                    if self.faceUpCardViewsMatch {
                        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.6, delay: 0, options: [], animations: {
                            cardsToAnimate.forEach {
                                $0.transform = CGAffineTransform.identity.scaledBy(x: 1.25, y: 1.25)
                            }
                        }, completion: { position in
                            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.75, delay: 0, options: [], animations: {
                                cardsToAnimate.forEach {
                                    $0.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                                    $0.alpha = 0
                                }
                            }, completion: { position in
                                cardsToAnimate.forEach {
                                    $0.isHidden = true
                                    $0.alpha = 1
                                    $0.transform = .identity
                                }
                            }
                            )
                        }
                        )
                    } else if self.faceUpCardViews.count == 2 {
                        if chosenCardView == self.lastChosenCardView {
                            cardsToAnimate.forEach { cardView in
                                UIView.transition(with: cardView, duration: 0.6, options: [.transitionFlipFromLeft], animations: {
                                    cardView.isFaceUp = false
                                }, completion: { finished in
                                    self.cardBehaviour.addItem(cardView)  //animation system closure, !memory cycle
                                }
                                )
                            }
                        }
                    } else {
                        if !chosenCardView.isFaceUp {
                            self.cardBehaviour.addItem(chosenCardView)  //completion handler closure, !memory cycle
                        }
                    }
                }
                )
            }
        default:
            break
        }
    }
}

extension CGFloat {
    var arc4random: CGFloat {
        return CGFloat(arc4random_uniform(UInt32(self*1000))) / 1000
    }
}
