//
//  Card.swift
//  Memory

import UIKit
import SwiftyJSON
import AVFoundation
import MusicalInstrument
import MusicSymbol


class Card {

    // MARK: - Properties
    
    var id: String
    var shown: Bool = false
    var artworkURL: UIImage!
    var soundId: UInt32 = 1016
    var note: String!
    
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
    
    init(image: UIImage, note: String) {
        self.id = NSUUID().uuidString
        self.shown = false
        self.artworkURL = image
        self.note = note
    }
    
    // MARK: - Methods
    
    func equals(_ card: Card) -> Bool {
        return (card.id == id)
    }
    
    func copy() -> Card {
        return Card(card: self)
    }
    
    func play() {
        //AudioServicesPlaySystemSound(soundId)
        let piano = Piano.default
        piano.play(at: Pitch(stringLiteral: self.note))
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            piano.stop(at: Pitch(stringLiteral: self.note))
        }
        
    }
}

extension Array {
    mutating func shuffle() {
        for _ in 0...self.count {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}
