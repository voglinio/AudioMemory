//
//  Card.swift
//  Memory

import UIKit
import SwiftyJSON
import AVFoundation


class Card {

    // MARK: - Properties
    
    var id: String
    var shown: Bool = false
    var artworkURL: UIImage!
    var soundId: UInt32 = 1016
    
    static var allCards = [Card]()

    init(card: Card) {
        self.id = card.id
        self.shown = card.shown
        self.artworkURL = card.artworkURL
        self.soundId = card.soundId
    }
    
    init(image: UIImage) {
        self.id = NSUUID().uuidString
        self.shown = false
        self.artworkURL = image
    }
    
    init(image: UIImage, soundId: UInt32) {
        self.id = NSUUID().uuidString
        self.shown = false
        self.artworkURL = image
        self.soundId = soundId
    }
    
    // MARK: - Methods
    
    func equals(_ card: Card) -> Bool {
        return (card.id == id)
    }
    
    func copy() -> Card {
        return Card(card: self)
    }
    
    func play() {
        AudioServicesPlaySystemSound(soundId)
    }
}

extension Array {
    mutating func shuffle() {
        for _ in 0...self.count {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}
