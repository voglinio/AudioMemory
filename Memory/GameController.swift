//
//  GameController.swift
//  Memory

import UIKit
import AFNetworking
// import this
import AVFoundation
import SwiftySound
import CoreMotion

/*
    Καλώς ήρθες στο παιχνίδι ακουστικής μνήμης! Η συσκευή που κρατάς στα χέρια σου έχει ένα
    ειδικό πλαίσιο, τέσσερα επί τέσσερα, με δεκαέξι κουμπιά. Σε κάθε κουμπί αντιστοιχεί ένας
    ήχος και υπάρχουν οχτώ διαφορετικοί ήχοι. Θα πρέπει να πατήσεις κάθε κουμπί με διπλό
    ταπ και θα ακούσεις έναν ήχο. Αν ταιριάξεις τους ήχους θα ακούσεις έναν ήχο επιτυχίας. Αν όχι θα ακούσεις έναν ήχο αποτυχίας.
 */


class GameController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timer: UILabel!
    
    let motionManager = CMMotionManager()


    var counter = 0
    var time = Timer()
    var timerRepeatIntro = Timer()
    var accelTimer = Timer()
    
    var disableMotion : Bool = false

    var introSound: Sound!
    var topLeftSound: Sound!
    var bottomRightSound: Sound!
    var bravoSound: Sound!
    var beginPlaySound: Sound!
    var successSound: Sound!
    var replaySound: Sound!
    var motionHandler: MotionHandler!
    var noiseSet: Sound!
    var notesSet: Sound!
    var soundSets: [Sound?] = []
    var prevRes: Int = 0

    
    fileprivate let sectionInsets = UIEdgeInsets(top: 40.0, left: 20, bottom: 40.0, right: 20)
    
    let game = MemoryGame()
    var cards = [Card]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        motionHandler = MotionHandler()
        
        motionManager.startAccelerometerUpdates()
        motionManager.startGyroUpdates()
        accelTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(updateAccel), userInfo: nil, repeats: true)


        setUpDoubleTap()
        initSounds()
        
        game.gamePhase = phaseJustStarted
        
        game.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isHidden = false
        collectionView.isUserInteractionEnabled = true
    
        
        APIClient.shared.getCardImages { (cardsArray, error) in
            if let _ = error {
                // show alert
            }

            self.cards = cardsArray!
            self.setupNewGame()
        }
        
    }
    
    func initSounds(){
        introSound = Sound(url: introUrl!)!
        introSound.volume = 1.0
        
        topLeftSound = Sound(url: topLeftSoundUrl!)!
        topLeftSound.volume = 1.0

        bottomRightSound = Sound(url: bottomRightSoundUrl!)!
        bottomRightSound.volume = 1.0
        
        bravoSound = Sound (url: bravoSoundUrl!)
        bravoSound.volume = 1.0
        
        beginPlaySound = Sound(url: beginPlaySoundUrl!)
        beginPlaySound.volume = 1.0
        
        successSound = Sound(url: successSoundUrl!)
        successSound.volume = 1.0
        
        replaySound = Sound(url: replaySoundUrl!)
        replaySound.volume = 1.0

        noiseSet = Sound(url: soundSetNoiseUrl!)
        noiseSet.volume = 1.0

        notesSet = Sound(url: soundSetNotesUrl!)
        notesSet.volume = 1.0
        
        soundSets = [notesSet, noiseSet]
        
        
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
    
    func startGameWithAudio(){
        resetGame()
        
        self.disableMotion = true
        introSound.play {
            completed in
            print("completed intro :  \(completed)")
            self.game.gamePhase = phaseIntro
            self.topLeftSound.play{
                completed in
                self.game.gamePhase = phaseUpperLeft
                self.disableMotion = false
                print("completed topleft : \(completed)", " - ", self.disableMotion)
            }
        }
    }
    
    func startGame(){
        counter = 0
        //timer.text = "00:00"
        
        time.invalidate()
        time = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(timerAction),
            userInfo: nil,
            repeats: true
        )
    }
    
    @objc func updateAccel() {
        
        if self.disableMotion == true{
            return
        }
        
        
        if let accelerometerData = motionManager.accelerometerData {
            let res = motionHandler.updateMotion(accelerometerData: accelerometerData)
            
            if res == MotionUpDown && prevRes != MotionUpDown{
                startGameWithAudio()

                 return
            }
            
            if res == MotionLeftRight  {
                game.soundIndex = (game.soundIndex + 1) % 2
                self.disableMotion = true
                
                soundSets[game.soundIndex]!.play {
                    complete in
                    self.disableMotion = false

                }

                return
            }


        }
        
        if let gyroData = motionManager.gyroData {
            let res = motionHandler.updateMotion(gyroData: gyroData)
            
        }
        
       
    }
        
    
    @IBAction func onStartGame(_ sender: Any) {
        counter = 0
        //timer.text = "00:00"
        
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
        //timer.text = "\(mm):\(ss)"
    }
    
    
    private var doubleTapGesture: UITapGestureRecognizer!
    func setUpDoubleTap() {
       doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapCollectionView))
       doubleTapGesture.numberOfTapsRequired = 2
       collectionView.addGestureRecognizer(doubleTapGesture)
       doubleTapGesture.delaysTouchesBegan = true
    }
    
    
    @objc func didDoubleTapCollectionView() {
       let pointInCollectionView = doubleTapGesture.location(in: collectionView)
       
        if self.game.gamePhase == phaseJustStarted {
            return
        }
        
        if self.game.gamePhase == phaseReplay {
            return
        }

        
        if self.game.gamePhase == phaseIntro {
            return
        }

       if let selectedIndexPath = collectionView.indexPathForItem(at: pointInCollectionView) {
           
           // Calibration phase upper left
           if self.game.gamePhase == phaseUpperLeft {
               if selectedIndexPath.row == 0 {
                   bravoSound.play{
                       completed in
                       self.bottomRightSound.play{
                           completed in
                           self.game.gamePhase = phaseLowerRight

                       }
                   }
                   return
               }else{
                   return
               }
           }

           // Calibration phase lower right
           if self.game.gamePhase == phaseLowerRight {
               if selectedIndexPath.row == 15 {
                   self.disableMotion = true
                   bravoSound.play {
                       completed in
                       print("completed bottom right :  \(completed)")
                       self.game.gamePhase = phaseLowerRight
                       
                       self.beginPlaySound.play{
                           completed in
                           self.game.gamePhase = phasePlay
                           self.disableMotion = false
                           self.startGame()
                       }
                   }
                   return
               }else{
                   return
               }
           }

           let cell = collectionView.cellForItem(at: selectedIndexPath) as! CardCell

           if cell.shown {
               switch UIDevice.current.model {
                   case "iPhone":
                       // It's an iPhone
                       AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                       print ("phone")
                       return
                   case "iPad":
                       // It's an iPad
                       AudioServicesPlaySystemSound(1006) // LowPower
                       print ("pad")
                       return
               
                   default:
                       // Uh, oh! What could it be?
                       AudioServicesPlaySystemSound(1006) // LowPower
                       AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                       return
               }
           }
           cell.card?.play(soundIdx: game.soundIndex)
           game.didSelectCard(cell.card)
           
           collectionView.deselectItem(at: selectedIndexPath, animated:true)
       }
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
        
        if self.game.gamePhase == phaseJustStarted {
            return
        }
        if self.game.gamePhase == phaseReplay {
            return
        }

        if self.game.gamePhase == phaseIntro {
            return
        }
        if self.game.gamePhase == phaseUpperLeft {
            return
        }
        if self.game.gamePhase == phaseLowerRight {
            return
        }

        if cell.shown {
            switch UIDevice.current.model {
                case "iPhone":
                    // It's an iPhone
                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    print ("phone")
                    return
                case "iPad":
                    // It's an iPad
                    AudioServicesPlaySystemSound(1006) // LowPower
                    print ("pad")
                    return
            
                default:
                    // Uh, oh! What could it be?
                    AudioServicesPlaySystemSound(1006) // LowPower
                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    return
            }
        }
//        cell.card?.play(isOn: self.toggleVisual.isOn)
//        game.didSelectCard(cell.card)
//
//        collectionView.deselectItem(at: indexPath, animated:true)

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
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
            self.successSound.play{
                completed in
                self.game.gamePhase = phaseReplay
                self.resetGame()
                self.replaySound.play()
            }

        }
       
 
    }
}

extension GameController: UICollectionViewDelegateFlowLayout {
    
    // Collection view flow layout setup
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = Int(sectionInsets.left) * 4
        let availableWidth = Int(view.frame.width) - paddingSpace
        let widthPerItem = availableWidth / 4
        
        let heightPaddingSpace = Int(sectionInsets.top) * 4
        let availableHeight = Int(view.frame.height) - heightPaddingSpace
        let heightPerItem = availableHeight / 4
        
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
