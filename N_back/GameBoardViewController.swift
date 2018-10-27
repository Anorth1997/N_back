//
//  ViewController.swift
//  N_back
//
//  Created by Ziyao. Chen on 2018-06-24.
//  Copyright © 2018 TalentedExplorer. All rights reserved.
//

import UIKit
import AVFoundation

class GameBoardViewController: UIViewController {
    
    
    // ------------------------------------------ Instance Variables and Constants -------------------------------------------
    
    
    // this is the model instance
    var game = Nback(level: Level.choosedefaultlevel(level: 1))
    
    // Timer instance used to control time delay among trials
    var timer:Timer?
    
    //Help to play the audio
    var audioPlayer = AVAudioPlayer()
    
    // The instance to write the CSV File
    var CSVWriter = CSVWrite()
    
    var customOption: String? {
        didSet {
            if self.customOption == "Adult" {
                
            } else if self.customOption == "Kid" {
                
            }
        }
    }
    
    var shapeValidButtonClick = false
    var positionValidButtonClick = false
    var colorValidButtonClick = false
    var soundValidButtonClick = false
    
    // Variable to keep whether the button was presses or not in each trial
    var buttonStatus: [String: Int] = ["shapeButton": 0,
                                       "positionButton": 0,
                                       "colorButton": 0,
                                       "soundButton": 0]
    
    // respond timers
    // Variables which are responsible for recording the respond time in each trial
    var shapeRT = RespondTimer()
    var positionRT = RespondTimer()
    var colorRT = RespondTimer()
    var soundRT = RespondTimer()
    var RTInformation: [String: String] = ["shapeRT": "",
                                           "positionRT": "",
                                           "colorRT": "",
                                           "soundRT": ""]
    
    
    var currentLine = [String]() // The line that we are going to send to the CSVWriter
    
    let shapeChoices: [Int: String] = [1: "shape1",
                                       2: "shape2",
                                       3: "shape3",
                                       4: "shape4",
                                       5: "shape5",
                                       6: "shape6",
                                       7: "shape7"]
    
    let soundChoices: [Int: String] = [1: "SampleA",
                                       2: "SampleB",
                                       3: "SampleC",
                                       4: "SampleD"]
    
    let colorChoices: [Int: UIColor] = [1: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1),
                                        2: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),
                                        3: #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1),
                                        4: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)]
    
    
    let fileColorChoices: [Int: String] = [1: "color1",
                                              2: "color2",
                                              3: "color3",
                                              4: "color4"]
    
    
    // the positionID of center grid
    let centreGrid = 4
    
    let fakeRandomParameter = 35 // the percent of change that the stimuli is the same as N-back one
    
    
    @IBOutlet weak var background: UIImageView!
    // The buttons
    @IBOutlet var Buttons: [UIButton]!
    
    // The grids
    @IBOutlet var Stimulus: [UILabel]!
    
    @IBOutlet weak var IntroductionMessage: UILabel!
    
    
    // ------------------------------------------ Event Handlers ----------------------------------------------
    
    @IBAction func gamestartButton(_ sender: UIButton) {
        CSVWriter.writeHeader()
        print("it's \(game.level!.numback) back")
        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { (timer) in
            self.runOneTrial()
        })
        IntroductionMessage.text = ""
    }
    
    @IBAction func PositionButton(_ sender: UIButton) {
        if positionValidButtonClick {
            game.checkPositionMatch(byPlayer: true)
            positionValidButtonClick = false
            buttonStatus["positionButton"] = 1
        }
        RTInformation["positionRT"] = positionRT.collectRespondTimeInfo()
    }
    
    @IBAction func ColorButton(_ sender: UIButton) {
        if colorValidButtonClick {
            game.checkColorMatch(byPlayer: true)
            colorValidButtonClick = false
            buttonStatus["colorButton"] = 1
        }
        
        RTInformation["colorRT"] = colorRT.collectRespondTimeInfo()
    }
    
    @IBAction func ShapeButton(_ sender: UIButton) {
        if shapeValidButtonClick {
            game.checkShapeMatch(byPlayer: true)
            shapeValidButtonClick = false
            buttonStatus["shapeButton"] = 1
        }
        RTInformation["shapeRT"] = shapeRT.collectRespondTimeInfo()
    }
    
    @IBAction func SoundButton(_ sender: UIButton) {
        if soundValidButtonClick {
            game.checkSoundMatch(byPlayer: true)
            soundValidButtonClick = false
            buttonStatus["soundButton"] = 1
        }
        RTInformation["soundRT"] = soundRT.collectRespondTimeInfo()
    }
    
    // ------------------------------------------------ Set Up -------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        for button in Buttons {
            if button.currentTitle == "Shape" {
                button.isHidden = !game.level!.tracking.shape
            }
            if button.currentTitle == "Position" {
                button.isHidden = !game.level!.tracking.position
            }
            if button.currentTitle == "Color" {
                button.isHidden = !game.level!.tracking.color
            }
            if button.currentTitle == "Sound" {
                button.isHidden = !game.level!.tracking.sound
            }
        }
        
        background.image = UIImage(named: "background.jpg")
        
        if game.level!.gridAppearance == false {
            for index in 0..<Stimulus.count {
                Stimulus[index].backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
        }
        
        
        if game.level!.changes.position == false {
            for index in 0..<Stimulus.count {
                if index != 4 {
                    Stimulus[index].backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                }
            }
        }
        
        // Introduce the level of the game
        let numback = self.game.level!.numback
        IntroductionMessage.text = "It's " + String(numback) + " back!"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "trialsend" {
            let accuracy = game.calculateaccuracy()
            print("\(accuracy)")
            if Int(game.level!.title) != nil { // this is a default level
                var currentlevel = Level.defaultlevels.firstKeyForValue(val: self.game.level!)
                if accuracy > 0.65 { // increment level
                    if currentlevel == 9 {
                        currentlevel = 0
                    } else if currentlevel != 0 {
                        currentlevel += 1
                    }
                } else if accuracy < 0.5 { // decrement level
                    if currentlevel == 0 {
                        currentlevel = 9
                    } else if currentlevel != 1 {
                        currentlevel -= 1
                    }
                }
                if let agvc = segue.destination as? AnotherGameViewController {
                    print("got here, now the current level is \(currentlevel)")
                    agvc.level = Level.choosedefaultlevel(level: currentlevel)
                }
            } else { // this is a customized level
                if let agvc = segue.destination as? AnotherGameViewController {
                    agvc.level = game.level
                }
            }
        }
    }
    
    
    // --------------------------------------------------- Instance Methods ----------------------------------------------
    
    func runOneTrial() {
        // appear for duration time
        if self.game.round == 1 {
            let randomshapeID: Int? = self.game.level!.changes.shape ? self.fakeRandomShape(originShape: nil) : nil
            let randompositionID: Int? = self.game.level!.changes.position ? self.fakeRandomPosition(originPosition: nil) : centreGrid
            let randomcolorID: Int? = self.game.level!.changes.color ? self.fakeRandomColor(originColor: nil) : nil
            let randomsoundID: Int? = self.game.level!.changes.sound ? self.fakeRandomSound(originSound: nil) : nil
            let randomOne = Stimuli(ShapeID: randomshapeID, PositionID: randompositionID, ColorID: randomcolorID, SoundID: randomsoundID)
            
            // The current Stimuli
            self.game.currentOne = randomOne
            
            print(self.game.currentOne!.shapeID!)
            
            // if color and shape option both true, that's a special case to handle
            if self.game.level!.changes.color && self.game.level!.changes.shape {
                let imagename_shape = shapeChoices[game.currentOne!.shapeID!]!
                let imagename_color = fileColorChoices[game.currentOne!.colorID!]!
                let full_imagename = imagename_shape + "_" + imagename_color
                
                let imageAttachment = NSTextAttachment()
                imageAttachment.image = UIImage(named: full_imagename)
                
                let imageString = NSAttributedString(attachment: imageAttachment)
                
                self.Stimulus[game.currentOne!.positionID!].attributedText = imageString
            } else {
                if self.game.level!.changes.color {
                    self.Stimulus[game.currentOne!.positionID!].backgroundColor = colorChoices[self.game.currentOne!.colorID!]
                }
                
                if self.game.level!.changes.shape {
                    let imagename = shapeChoices[game.currentOne!.shapeID!]!
                    let imageAttachment = NSTextAttachment()
                    imageAttachment.image = UIImage(named: imagename)
                    
                    let imageString = NSAttributedString(attachment: imageAttachment)
                    self.Stimulus[game.currentOne!.positionID!].attributedText = imageString
                }
            }
            
            if self.game.level!.changes.sound {
                do {
                    self.audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: soundChoices[self.game.currentOne!.soundID!], ofType: "m4a")!))
                    self.audioPlayer.prepareToPlay()
                }
                catch {
                    print(error)
                }
                self.audioPlayer.play()
            }
        }
            
        else if self.game.round > 1 {
            let randomshapeID: Int? = self.game.level!.changes.shape ? self.fakeRandomShape(originShape: self.game.nbackones[0].shapeID) : nil
            let randompositionID: Int? = self.game.level!.changes.position ? self.fakeRandomPosition(originPosition: self.game.nbackones[0].positionID) : centreGrid
            let randomcolorID: Int? = self.game.level!.changes.color ? self.fakeRandomColor(originColor: self.game.nbackones[0].colorID) : nil
            let randomsoundID: Int? = self.game.level!.changes.sound ? self.fakeRandomSound(originSound: self.game.nbackones[0].soundID) : nil
            
            let current = Stimuli(ShapeID: randomshapeID, PositionID: randompositionID, ColorID: randomcolorID, SoundID: randomsoundID)
            
            self.game.currentOne = current
            
            print(self.game.currentOne!.shapeID!)

            
            // if color and shape option both true, that's a special case to handle
            if self.game.level!.changes.color && self.game.level!.changes.shape {
                if self.game.level!.tracking.color {
                    self.game.checkColorMatch(byPlayer: false)
                }
                if self.game.level!.tracking.shape {
                    self.game.checkShapeMatch(byPlayer: false)
                }
                
                let imagename_shape = shapeChoices[game.currentOne!.shapeID!]!
                let imagename_color = fileColorChoices[game.currentOne!.colorID!]!
                let full_imagename = imagename_shape + "_" + imagename_color
                
                let imageAttachment = NSTextAttachment()
                imageAttachment.image = UIImage(named: full_imagename)
                
                let imageString = NSAttributedString(attachment: imageAttachment)
                
                self.Stimulus[game.currentOne!.positionID!].attributedText = imageString
            } else {
                if self.game.level!.changes.color {
                    if self.game.level!.tracking.color {
                        self.game.checkColorMatch(byPlayer: false)
                    }
                    self.Stimulus[game.currentOne!.positionID!].backgroundColor = colorChoices[self.game.currentOne!.colorID!]
                }
                if self.game.level!.changes.shape {
                    if self.game.level!.tracking.shape {
                        self.game.checkShapeMatch(byPlayer: false)
                    }
                    let imagename = shapeChoices[game.currentOne!.shapeID!]!
                    let imageAttachment = NSTextAttachment()
                    imageAttachment.image = UIImage(named: imagename)
                    
                    let imageString = NSAttributedString(attachment: imageAttachment)
                    self.Stimulus[game.currentOne!.positionID!].attributedText = imageString
                }
            }
            
            if self.game.level!.changes.position {
                if self.game.level!.tracking.position {
                    self.game.checkPositionMatch(byPlayer: false)
                }
            }
            
            if self.game.level!.changes.sound {
                if self.game.level!.tracking.sound {
                    self.game.checkSoundMatch(byPlayer: false)
                }
                do {
                    self.audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: soundChoices[self.game.currentOne!.soundID!], ofType: "m4a")!))
                    self.audioPlayer.prepareToPlay()
                }
                catch {
                    print(error)
                }
                self.audioPlayer.play()
            }
            
            shapeValidButtonClick = true
            positionValidButtonClick = true
            colorValidButtonClick = true
            soundValidButtonClick = true
            
            
            // start counting the respond timers
            initiateRTs()
        }
        

        // disappear for
        timer = Timer.scheduledTimer(withTimeInterval: game.level!.duration, repeats: false, block: { (timer) in
            let pos = self.findActivatedStimuliFromView()
            if self.game.level!.changes.color {
                self.Stimulus[pos].backgroundColor = self.game.level!.gridAppearance ? #colorLiteral(red: 0.7952535152, green: 0.7952535152, blue: 0.7952535152, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
            if self.game.level!.changes.shape {
                self.Stimulus[pos].text?.removeAll()
            }
            
            self.shapeValidButtonClick = false
            self.positionValidButtonClick = false
            self.colorValidButtonClick = false
            self.soundValidButtonClick = false
            
            self.shapeRT.shutdownTimer()
            self.positionRT.shutdownTimer()
            self.colorRT.shutdownTimer()
            self.soundRT.shutdownTimer()
            
            self.onTick()
        })
    } 
    
    
    // Initiate the next trial, if all trials are finished, go to the next view
    private func onTick() {
        self.sendToCSV()
        game.round += 1
        if game.round <= game.level!.trials {
            timer = Timer.scheduledTimer(withTimeInterval: game.level!.ISI, repeats: false, block: {(timer) in
                self.game.recordanddrop()
                self.runOneTrial()
            })
        } else {
            timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (timer) in
                self.performSegue(withIdentifier: "trialsend", sender: self)
        })}
    }
    
    private func initiateRTs() {
        if game.level!.trials > game.level!.numback {
            if game.level!.tracking.shape {
                shapeRT.startCountingRespondTime()
            }
            if game.level!.tracking.position {
                positionRT.startCountingRespondTime()
            }
            if game.level!.tracking.color {
                colorRT.startCountingRespondTime()
            }
            if game.level!.tracking.sound {
                soundRT.startCountingRespondTime()
            }
        }
    }
    
    
    // Send the details of each trial to CSVWriter, and write the csv file
    private func sendToCSV() {
        
        // trial #
        currentLine.append(String(game.round))
        
        // block #
        if game.level!.changes.position {
            currentLine.append(String(self.Stimulus.count))
        } else {
            currentLine.append("1")
        }
        
        // level #
        currentLine.append(String(game.level!.title))
        
        // changes options setting
        appendNumericBool(option: game.level!.changes.shape)
        appendNumericBool(option: game.level!.changes.position)
        appendNumericBool(option: game.level!.changes.color)
        appendNumericBool(option: game.level!.changes.sound)
        
        // tracking options setting
        appendNumericBool(option: game.level!.tracking.shape)
        appendNumericBool(option: game.level!.tracking.position)
        appendNumericBool(option: game.level!.tracking.color)
        appendNumericBool(option: game.level!.tracking.sound)
        
        // numback
        currentLine.append(String(game.level!.numback))
        
        // duration
        currentLine.append(String(game.level!.duration))
        
        // ISI
        currentLine.append(String(game.level!.ISI))
        // gridAppearance
        if game.level!.gridAppearance {
            currentLine.append("1")
        } else {
            currentLine.append("0")
        }
        // object ID
        appendOptionID(changesOption: game.level!.changes.shape, ID: game.currentOne!.shapeID)
        
        // position ID
        /* not using the appendOptionID helper function here, because the positionID corresponds to
         * the index of grids in self.Stimulus, and it starts from 0, but we want the positionID in output CSV file
         * start from 1. This is a lazy way of solving the problem. We all lazy.
         */
        if game.level!.changes.position {
            currentLine.append(String(game.currentOne!.positionID! + 1))
        } else {
            currentLine.append("0")
        }
        // color ID
        appendOptionID(changesOption: game.level!.changes.color, ID: game.currentOne!.colorID)
        
        // sound ID
        appendOptionID(changesOption: game.level!.changes.sound, ID: game.currentOne!.soundID)
        
        // Object Button
        currentLine.append(String(buttonStatus["shapeButton"]!))
        // Position Button
        currentLine.append(String(buttonStatus["positionButton"]!))
        // Color Button
        currentLine.append(String(buttonStatus["colorButton"]!))
        // Sound Button
        currentLine.append(String(buttonStatus["soundButton"]!))
        
        buttonStatusReset()
        
        // Answers
        AnswerCheckAndAppend()


        
        // Object RT
        if game.level!.tracking.shape {
            if RTInformation["shapeRT"]! == "" {
                currentLine.append("0")
            } else {
                currentLine.append(RTInformation["shapeRT"]!)
            }
        } else {
            currentLine.append("X")
        }
        
        // Position RT
        if game.level!.tracking.position {
            if RTInformation["positionRT"]! == "" {
                currentLine.append("0")
            } else {
                currentLine.append(RTInformation["positionRT"]!)
            }
        } else {
            currentLine.append("X")
        }


        // Color RT
        if game.level!.tracking.color {
            if RTInformation["colorRT"]! == "" {
                currentLine.append("0")
            } else {
                currentLine.append(RTInformation["colorRT"]!)
            }
        } else {
            currentLine.append("X")
        }


        // Sound RT
        if game.level!.tracking.sound {
            if RTInformation["soundRT"]! == "" {
                currentLine.append("0")
            } else {
                currentLine.append(RTInformation["soundRT"]!)
            }
        } else {
            currentLine.append("X")
        }
        
        clearRTInformation()
        
        CSVWriter.writeLine(elements: currentLine)
        currentLine = [String]()
    }
    
    // Helper function to write in the Answers of each trial in CSV file
    private func AnswerCheckAndAppend() {
        if game.level!.tracking.shape {
            if game.level!.numback == game.nbackones.count {
                if game.currentOne!.shapeID! == game.nbackones[0].shapeID! {
                    currentLine.append("1")
                } else {
                    currentLine.append("0")
                }
            } else {
                currentLine.append("0")
            }
        } else {
            currentLine.append("X")
        }
        
        if game.level!.tracking.position {
            if game.level!.numback == game.nbackones.count {
                if game.currentOne!.positionID! == game.nbackones[0].positionID! {
                    currentLine.append("1")
                } else {
                    currentLine.append("0")
                }
            } else {
                currentLine.append("0")
            }
        } else {
            currentLine.append("X")
        }
        
        if game.level!.tracking.color {
            if game.level!.numback == game.nbackones.count {
                if game.currentOne!.colorID! == game.nbackones[0].colorID! {
                    currentLine.append("1")
                } else {
                    currentLine.append("0")
                }
            } else {
                currentLine.append("0")
            }
        } else {
            currentLine.append("X")
        }
        
        if game.level!.tracking.sound {
            if game.level!.numback == game.nbackones.count {
                if game.currentOne!.soundID! == game.nbackones[0].soundID! {
                    currentLine.append("1")
                } else {
                    currentLine.append("0")
                }
            } else {
                currentLine.append("0")
            }

        } else {
            currentLine.append("X")
        }
    }
    
    private func clearRTInformation() {
        for info in RTInformation {
            RTInformation.updateValue("", forKey: info.key)
        }
    }
    
    // helper function to append in currentLine, if options is true, append 1, else append 0
    private func appendNumericBool(option: Bool) {
        if option {
            currentLine.append("1")
        } else {
            currentLine.append("0")
        }
    }
    
    // helper function to append in currentLine, if change.option is true, then write in the corresponding option ID, else write in 0 which represents null.
    private func appendOptionID(changesOption: Bool, ID: Int?) {
        if changesOption {
            currentLine.append(String(ID!))
        } else {
            currentLine.append("0")
        }
    }
    
    private func buttonStatusReset() {
        for button in buttonStatus {
            buttonStatus.updateValue(0, forKey: button.key)
        }
    }
    
    // This function is responsible for the algorithm to random the position
    private func fakeRandomPosition(originPosition: Int?) -> Int{
        if originPosition != nil {
            if 100.arc4random <= fakeRandomParameter { // 35 percent of chance the same as Nback one
                return originPosition!
            } else {
                return self.Stimulus.count.arc4random
            }
        } else {
            return self.Stimulus.count.arc4random
        }
    }
    
    // This function is responsible for the algorithm to random the color
    private func fakeRandomColor(originColor: Int?) -> Int {
        if originColor != nil {
            if 100.arc4random <= fakeRandomParameter { // 35 percent of chance the same as Nback one
                return originColor!
            } else {
                return colorChoices.count.arc4randomfrom1
            }
        } else {
            return colorChoices.count.arc4randomfrom1
        }
    }
    
    // This function is responsible for the algorithm to random the Shape
    private func fakeRandomShape(originShape: Int?) -> Int {
        if originShape != nil {
            if 100.arc4random <= fakeRandomParameter { // 35 percent of chance the same as Nback one
                return originShape!
            } else {
                return shapeChoices.count.arc4randomfrom1
            }
        } else {
            return shapeChoices.count.arc4randomfrom1
        }
    }
    
    // This function is responsible for the algorithm to random the Sound
    private func fakeRandomSound(originSound: Int?) -> Int {
        if originSound != nil {
            if 100.arc4random <= fakeRandomParameter { // 35 percent of chance the same as Nback one
                return originSound!
            } else {
                return soundChoices.count.arc4randomfrom1
            }
        } else {
            return soundChoices.count.arc4randomfrom1
        }
    }
    
    
    // helper function to find the activated grid's positionID
    private func findActivatedStimuliFromView() -> Int {
        if self.game.level!.changes.position {
            return self.game.currentOne!.positionID!
        } else {
            return centreGrid
        }
    }


    

}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
    
    var arc4randomfrom1: Int { // return a random number in range 1...self
        return self.arc4random + 1
    }
}

extension Array {
    var lastone: Element {
        return self[self.count - 1]
    }
}

