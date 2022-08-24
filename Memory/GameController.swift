//
//  GameController.swift
//  Memory

import UIKit
import AFNetworking
// import this
import AVFoundation

class GameController: UIViewController {

    @IBOutlet weak var toggleVisual: UISwitch!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timer: UILabel!

    var counter = 0
    var time = Timer()
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 10, bottom: 10.0, right: 10)
    
    let game = MemoryGame()
    var cards = [Card]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       

        // create a sound ID, in this case its the tweet sound.
        //let systemSoundID: SystemSoundID = 1016

        // to play sound
        
        game.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isHidden = true
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if game.isPlaying {
            resetGame()
        }
    }
    
    func setupNewGame() {
        cards = game.newGame(cardsArray: self.cards)
        collectionView.reloadData()
    }
    
    func resetGame() {
        game.restartGame()
        setupNewGame()
    }
    
    @IBAction func onStartGame(_ sender: Any) {
        collectionView.isHidden = false
        
        if self.toggleVisual.isOn {
            APIClient.shared.getCardImages { (cardsArray, error) in
                if let _ = error {
                    // show alert
                }
                
                self.cards = cardsArray!
                self.setupNewGame()
            }
        }else{
            APIClient.shared.getCardSingleImage { (cardsArray, error) in
                if let _ = error {
                    // show alert
                }
                
                self.cards = cardsArray!
                self.setupNewGame()
            }
        }
        
        
        counter = 0
        timer.text = "00:00"
        
        time.invalidate()
        time = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(timerAction),
            userInfo: nil,
            repeats: true
            
        )
    }
    
    func secondsToMinutesSeconds(_ seconds: Int) -> (Int, Int) {
        return ( (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func getStringFrom(seconds: Int) -> String {

        return seconds < 10 ? "0\(seconds)" : "\(seconds)"
    }
    
    @objc func timerAction() {
        counter += 1
        let (m, s) = secondsToMinutesSeconds (counter)
        let mm = getStringFrom(seconds: m)
        let ss = getStringFrom(seconds: s)
        timer.text = "\(mm):\(ss)"
        
        print (toggleVisual.isOn)

    }
}

// MARK: - CollectionView Delegate Methods
extension GameController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCell
        cell.showCard(false, animted: false)
        
        guard let card = game.cardAtIndex(indexPath.item) else { return cell }
        cell.card = card
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CardCell
        
        if cell.shown { return }
        print (cell.card)
        cell.card?.play()
        game.didSelectCard(cell.card)
        
        collectionView.deselectItem(at: indexPath, animated:true)

    }
}

// MARK: - MemoryGameProtocol Methods
extension GameController: MemoryGameProtocol {
    
    func memoryGameDidStart(_ game: MemoryGame) {
        collectionView.reloadData()
    }
    
    func memoryGame(_ game: MemoryGame, showCards cards: [Card]) {
        for card in cards {
            guard let index = game.indexForCard(card) else { continue }
            let cell = collectionView.cellForItem(at: IndexPath(item: index, section:0)) as! CardCell
            cell.showCard(true, animted: true)
        }
    }
    
    func memoryGame(_ game: MemoryGame, hideCards cards: [Card]) {
        for card in cards {
            guard let index = game.indexForCard(card) else { continue }
            let cell = collectionView.cellForItem(at: IndexPath(item: index, section:0)) as! CardCell
            cell.showCard(false, animted: true)
        }
    }
    
    func memoryGameDidEnd(_ game: MemoryGame) {
        time.invalidate()
        
        let alertController = UIAlertController(
            title: defaultAlertTitle,
            message: defaultAlertMessage,
            preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "No!", style: .cancel) { [weak self] (action) in
            self?.collectionView.isHidden = true
        }
        let playAgainAction = UIAlertAction(title: "Yes!", style: .default) { [weak self] (action) in
            self?.collectionView.isHidden = true
            self?.resetGame()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(playAgainAction)
        
        self.present(alertController, animated: true) { }
        
        resetGame()
    }
}

extension GameController: UICollectionViewDelegateFlowLayout {
    
    // Collection view flow layout setup
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = Int(sectionInsets.left) * 4
        let availableWidth = Int(view.frame.width) - paddingSpace
        let widthPerItem = availableWidth / 4
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
