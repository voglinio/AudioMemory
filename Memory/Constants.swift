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


let introUrl = Bundle.main.url(forResource: "game_intro_xtd_v2", withExtension: "wav")
let topLeftSoundUrl = Bundle.main.url(forResource: "double_tap_top_left", withExtension: "wav")
let bottomRightSoundUrl = Bundle.main.url(forResource: "double_tap_bottom_right", withExtension: "wav")
let bravoSoundUrl = Bundle.main.url(forResource: "bravo", withExtension: "wav")
let beginPlaySoundUrl = Bundle.main.url(forResource: "begin_play", withExtension: "wav")

let successSoundUrl =  Bundle.main.url(forResource: "congrats", withExtension: "wav")
let replaySoundUrl = Bundle.main.url(forResource: "new_game", withExtension: "wav")
