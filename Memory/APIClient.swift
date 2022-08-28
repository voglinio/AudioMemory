//
//  APIClient.swift
//  Memory

import Foundation
import AFNetworking
import SwiftyJSON

typealias CardsArray = [Card]

// MARK: - APIClient
class APIClient: AFHTTPSessionManager {
    
    struct URLHosts {
        static let baseURL = "https://source.unsplash.com/"
        static let random = "random/"
        static let category = "category/"
    }
    
    static let shared = APIClient()
    
    static var defaultCardImages:[UIImage] = [
        UIImage(named: "card")!,
        UIImage(named: "card")!,
        UIImage(named: "card")!,
        UIImage(named: "card")!,
        UIImage(named: "card")!,
        UIImage(named: "card")!,
        UIImage(named: "card")!,
        UIImage(named: "card")!

    ];
    
    static var constantCardImages:[UIImage] = [
        UIImage(named: "card")!,
        UIImage(named: "card")!,
        UIImage(named: "card")!,
        UIImage(named: "card")!,
        UIImage(named: "card")!,
        UIImage(named: "card")!,
        UIImage(named: "card")!,
        UIImage(named: "card")!
    ];
    
    static var errorSound: UInt32 = 1073
    static var successSound: UInt32 = 1001
    
    
    static var defaultCardSounds:[UInt32] = [
        1307,
        1333,
        1309,
        1310,
        1022,
        1313,
        1016,
        1302
    ];
    
    static var errorWav: String = "miss"
    static var succeWav: String = "succ"
    
    static var defaulNotes:[String] = [
        "noteA2",
        "noteB2",
        "noteC2",
        "noteC3",
        "noteD2",
        "noteE2",
        "noteF2",
        "noteG2"
    ];
    static var defaulNoise:[String] = [
        "band",
        "bass",
        "bats",
        "bips",
        "blin",
        "blow",
        "briz",
        "buss"
    ];
    
    func getCardImages(completion: ((CardsArray?, Error?) -> ())?) {
        var cards = CardsArray()
        
        
        let cardImages = APIClient.defaultCardImages
        let cardISounds = APIClient.defaultCardSounds
        let cardINotes = APIClient.defaulNotes
        let cardINoise = APIClient.defaulNoise

        for (image, (note, noise)) in zip(cardImages, zip(cardINotes, cardINoise)) {
            let card = Card(image: image, note: note, noise: noise)
            let copy = card.copy()
            copy.note = card.note
            copy.noise = card.noise

            cards.append(card)
            cards.append(copy)
        }
        
        completion!(cards, nil)
    }
    
    
    func getCardSingleImage(completion: ((CardsArray?, Error?) -> ())?) {
        var cards = CardsArray()
        
        
        let cardImages = APIClient.constantCardImages
        let cardISounds = APIClient.defaultCardSounds
        let cardINotes = APIClient.defaulNotes


        for (image, soundId) in zip(cardImages, cardINotes) {
            let card = Card(image: image, note: soundId)
            let copy = card.copy()
            copy.note = card.note

            
            cards.append(card)
            cards.append(copy)
        }
        
        completion!(cards, nil)
    }
}
