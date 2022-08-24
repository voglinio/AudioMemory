//
//  APIClient.swift
//  Memory

import Foundation
import AFNetworking
import SwiftyJSON
import MusicSymbol

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
        UIImage(named: "1")!,
        UIImage(named: "2")!,
        UIImage(named: "3")!,
        UIImage(named: "4")!,
        UIImage(named: "5")!,
        UIImage(named: "6")!,
        UIImage(named: "7")!,
        UIImage(named: "8")!
    ];
    
    static var constantCardImages:[UIImage] = [
        UIImage(named: "1")!,
        UIImage(named: "1")!,
        UIImage(named: "1")!,
        UIImage(named: "1")!,
        UIImage(named: "1")!,
        UIImage(named: "1")!,
        UIImage(named: "1")!,
        UIImage(named: "1")!
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
    
    static var defaulNotes:[String] = [
        "A2",
        "B2",
        "C2",
        "C3",
        "D2",
        "E2",
        "F2",
        "G2"
    ];
    
    func getCardImages(completion: ((CardsArray?, Error?) -> ())?) {
        var cards = CardsArray()
        
        
        let cardImages = APIClient.defaultCardImages
        let cardISounds = APIClient.defaultCardSounds
        let cardINotes = APIClient.defaulNotes

        for (image, note) in zip(cardImages, cardINotes) {
            let card = Card(image: image, note: note)
            let copy = card.copy()
            copy.note = card.note
            
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
