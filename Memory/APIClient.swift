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
        UIImage(named: "1")!,
        UIImage(named: "2")!,
        UIImage(named: "3")!,
        UIImage(named: "4")!,
        UIImage(named: "5")!,
        UIImage(named: "6")!,
        UIImage(named: "7")!,
        UIImage(named: "8")!
    ];
    
    static var defaultCardSounds:[UInt32] = [
        1000,
        1333,
        1309,
        1310,
        1022,
        1313,
        1016,
        1302
    ];
    
    func getCardImages(completion: ((CardsArray?, Error?) -> ())?) {
        var cards = CardsArray()
        let cardImages = APIClient.defaultCardImages
        let cardISounds = APIClient.defaultCardSounds

        for (image, soundId) in zip(cardImages, cardISounds) {
            let card = Card(image: image, soundId: soundId)
            let copy = card.copy()
            
            cards.append(card)
            cards.append(copy)
        }
        
        completion!(cards, nil)
    }
}
