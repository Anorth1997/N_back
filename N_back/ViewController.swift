//
//  ViewController.swift
//  N_back
//
//  Created by Ziyao. Chen on 2018-06-24.
//  Copyright © 2018 TalentedExplorer. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    private lazy var game = Nback(numberofStimulus: numberOfStimulus)
    
    var numberOfStimulus: Int {
        return Stimulus.count
    }
    
    var chosenOne: (Position: Int?, Color: UIColor?, Shape: String?, Sound: String?)
    
    var NBackOne: (Position: Int?, Color: UIColor?, Shape: String?, Sound: String?)
    
    var round = 0
    
    var score = 0
    
    var timer:Timer?
    
    var audioPlayer = AVAudioPlayer()
    
    @IBOutlet var Stimulus: [UILabel]!
    
    @IBAction func runtimer(_ sender: UIButton) {
        runtimer()
    }
    
    func runtimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (timer) in
            if self.round > 0 {
                self.NBackOne.Position = self.chosenOne.Position
                self.NBackOne.Color = self.chosenOne.Color
                self.NBackOne.Shape = self.chosenOne.Shape
                self.NBackOne.Sound = self.chosenOne.Sound
            }
            self.chosenOne.Position = self.fakeRandomPosition(originPosition: self.chosenOne.Position)
            self.chosenOne.Color = self.fakeRandomColor(originColor: self.chosenOne.Color)
            self.chosenOne.Shape = self.fakeRandomShape(originShape: self.chosenOne.Shape)
            self.chosenOne.Sound = self.fakeRandomSound(originSound: self.chosenOne.Sound)
            self.activateAndDeactivate()
            self.onTick()
        })
    }
    
    func onTick() {
        round += 1
        if round < 10 {
            runtimer()
        } else {
            print("\(score)")
        }
    }
    
    
    // This function is responsible for the algorithm to random the position
    func fakeRandomPosition(originPosition: Int?) -> Int{
        if chosenOne.Position != nil {
            if 100.arc4random <= 20 {
                return originPosition!
            } else {
                return self.Stimulus.count.arc4random
            }
        } else {
            return self.Stimulus.count.arc4random
        }
    }
    
    // This function is responsible for the algorithm to random the color
    func fakeRandomColor(originColor: UIColor?) -> UIColor {
        if chosenOne.Color != nil {
            if 100.arc4random <= 20 {
                return originColor!
            } else {
                return UIColor.random()
            }
        } else {
            return UIColor.random()
        }
    }
    
    // This function is responsible for the algorithm to random the Shape
    func fakeRandomShape(originShape: String?) -> String {
        if chosenOne.Shape != nil {
            if 100.arc4random <= 20 {
                return originShape!
            } else {
                return self.shapeChoices[self.shapeChoices.count.arc4random]
            }
        } else {
            return self.shapeChoices[self.shapeChoices.count.arc4random]
        }
    }
    
    // This function is responsible for the algorithm to random the Sound
    func fakeRandomSound(originSound: String?) -> String {
        if chosenOne.Sound != nil {
            if 100.arc4random <= 20 {
                return originSound!
            } else {
                return self.soundChoices[self.soundChoices.count.arc4random]
            }
        } else {
            return self.soundChoices[self.soundChoices.count.arc4random]
        }
    }
    
    private func activateAndDeactivate() {
        let active = UIViewPropertyAnimator(duration: 1.5, curve: .linear, animations: {self.Stimulus[self.chosenOne.Position!].backgroundColor = self.chosenOne.Color!
             self.Stimulus[self.chosenOne.Position!].text = self.chosenOne.Shape!
            do {
                self.audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: self.chosenOne.Sound!, ofType: "m4a")!))
                self.audioPlayer.prepareToPlay()
            }
            catch {
                print(error)
            }
            self.audioPlayer.play()
        })
        
        let deactive = UIViewPropertyAnimator(duration: 1.5, curve: .linear, animations: {self.Stimulus[self.chosenOne.Position!].backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
             self.Stimulus[self.chosenOne.Position!].text?.removeAll()
        })
        
        active.startAnimation()
        
        let _ = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { (deactivetimer) in
            deactive.startAnimation()
        })
    }
    
    @IBAction func PositionButton(_ sender: UIButton) {
        if self.NBackOne.Position != nil, self.chosenOne.Position != nil, self.NBackOne.Position! == self.chosenOne.Position! {
            self.score += 1
        }
    }
    
    @IBAction func ColorButton(_ sender: UIButton) {
        if self.NBackOne.Color != nil, self.chosenOne.Color != nil,
            self.NBackOne.Color! == self.chosenOne.Color! {
            self.score += 1
        }
    }
    
    @IBAction func ShapeButton(_ sender: UIButton) {
        if self.NBackOne.Shape != nil, self.chosenOne.Shape != nil,
            self.NBackOne.Shape! == self.chosenOne.Shape! {
            self.score += 1
        }
    }
    
    @IBAction func SoundButton(_ sender: UIButton) {
        if self.NBackOne.Sound != nil, self.chosenOne.Sound != nil,
            self.NBackOne.Sound! == self.chosenOne.Sound! {
            self.score += 1
        }
    }
    
    var shapeChoices = ["👻","💍","🐙","⚽️","🎃","🤖","👾"]
    var soundChoices = ["SampleA", "SampleB", "SampleC", "SampleD"]
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
}

extension UIColor {
    static func random() -> UIColor {
        return randomSet[randomSet.count.arc4random]
    }
    static var randomSet: [UIColor] = [#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)]
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random())
    }
}

