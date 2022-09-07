//
//  Constants.swift
//  Memory
import UIKit

// MARK: - Key Values

let keyArtworkURL = "artwork_url"
let keyTracks = "tracks"
let keyID = "id"

// MARK: - Default Values

let defaultGridSize = 4 * 4
let defaultAlertTitle = "Good job, Memory Master!"
let defaultAlertMessage = "Want to play again?"

let phaseJustStarted    = -1

let phaseIntro          = 1
let phaseUpperLeft      = 2
let phaseLowerRight     = 3
let phasePlay           = 4
let phaseReplay         = 5
let phaseAllagiIxou     = 6


let introUrl = Bundle.main.url(forResource: "ixos-eisagogis-xtd", withExtension: "wav")
let topLeftSoundUrl = Bundle.main.url(forResource: "pano-aristera-tetragono", withExtension: "wav")
let bottomRightSoundUrl = Bundle.main.url(forResource: "kato-deksia-tetragono", withExtension: "wav")
let bravoSoundUrl = Bundle.main.url(forResource: "bravo", withExtension: "wav")
let beginPlaySoundUrl = Bundle.main.url(forResource: "arxi-paixnidiou", withExtension: "wav")

let successSoundUrl =  Bundle.main.url(forResource: "sigxaritiria", withExtension: "wav")
let replaySoundUrl = Bundle.main.url(forResource: "new_game", withExtension: "wav")

let soundSetNotesUrl = Bundle.main.url(forResource: "notea2_g2", withExtension: "wav")
let soundSetNoiseUrl = Bundle.main.url(forResource: "band_noise", withExtension: "wav")

let allagiIxouUrl = Bundle.main.url(forResource: "protropi-allagi-set-ixou", withExtension: "wav")

let epelexesIxoUrl = Bundle.main.url(forResource: "allagi-ixou-set", withExtension: "wav")

let otanUrl = Bundle.main.url(forResource: "ixos-ekinisis-kiniseis", withExtension: "wav")

