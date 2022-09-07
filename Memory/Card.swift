//
//  Card.swift
//  Memory

import UIKit
import SwiftyJSON
import AVFoundation
import SwiftySound



class Card {

    // MARK: - Properties
    
    var id: String
    var shown: Bool = false
    var artworkURL: UIImage!
    var soundId: Int = 0
    var note: String!
    var noise: String!
    var sound: Sound!

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
    
    init(image: UIImage, soundId: Int) {
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
    
    init(image: UIImage, note: String, noise: String) {
        self.id = NSUUID().uuidString
        self.shown = false
        self.artworkURL = image
        self.note = note
        self.noise = noise
       
    }
    
    // MARK: - Methods
    
    func equals(_ card: Card) -> Bool {
        return (card.id == id)
    }
    
    func copy() -> Card {
        return Card(card: self)
    }
    
    func play(soundIdx: Int) {
        // 1st version
        // AudioServicesPlaySystemSound(soundId)
        
        // 2nd version using Piano/Violin
//        let piano = Piano.default
//        piano.play(at: Pitch(stringLiteral: self.note))
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
//            piano.stop(at: Pitch(stringLiteral: self.note))
//        }
        
        // 3rd version using Manos's wav files
        var effSoundIdx = soundIdx
        if effSoundIdx < 0{
            effSoundIdx = 0
        }
        let note = APIClient.sounds[effSoundIdx][Int(self.soundId)]
        print (effSoundIdx, self.soundId, note)
        Sound.play(file: note, fileExtension: "wav")
                
    }
}

extension Array {
    mutating func shuffle() {
        for _ in 0...self.count {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}
