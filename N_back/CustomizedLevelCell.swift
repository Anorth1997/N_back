//
//  LevelCell.swift
//  N_back
//
//  Created by Ziyao. Chen on 2018-07-29.
//  Copyright © 2018 TalentedExplorer. All rights reserved.
//

import UIKit

protocol CustomizedLevelCellDelegate {
    func didTapGo(level: Level)
}


class CustomizedLevelCell: UITableViewCell {

    var player: CustomPlayer?
    var level : Level?
    var delegate: CustomizedLevelCellDelegate?
    
    @IBAction func GoButton(_ sender: UIButton) {
        delegate?.didTapGo(level: level!)
    }
    
    @IBOutlet weak var LevelDescriptionLabel: UILabel!
    
    func setLevel(levelInfo: CustomizedLevel) {
        setLevelDescription(levelInfo: levelInfo)
        setLevelInfo(levelInfo: levelInfo)
    }
    
    private func setLevelDescription(levelInfo: CustomizedLevel) {
        var description = ""
        description += levelInfo.title + ", "
        
        description += "changes: "
        for option in levelInfo.changesoptions {
            description += option
            description += ", "
        }
        
        description += "tracking: "
        for option in levelInfo.trackingoptions {
            description += option
            description += ", "
        }
        
        description += "trials: " + String(levelInfo.trials) + ", "
        description += "duration: " + String(levelInfo.duration) + ", "
        description += "numback: " + String(levelInfo.numback) + ", "
        description += "ISI" + String(levelInfo.ISI) + ", "
        description += "gridAppearance" + String(levelInfo.gridAppearance)
        
        
        LevelDescriptionLabel.text = description
    }
    
    private func setLevelInfo(levelInfo: CustomizedLevel) {
        var changesOptions: (shape: Bool, position: Bool, color: Bool, sound:Bool)
        changesOptions.shape = levelInfo.changesoptions.contains("shape")
        changesOptions.position = levelInfo.changesoptions.contains("position")
        changesOptions.color = levelInfo.changesoptions.contains("color")
        changesOptions.sound = levelInfo.changesoptions.contains("sound")

        var trackingOptions: (shape: Bool, position: Bool, color: Bool, sound:Bool)
        trackingOptions.shape = levelInfo.trackingoptions.contains("shape")
        trackingOptions.position = levelInfo.trackingoptions.contains("position")
        trackingOptions.color = levelInfo.trackingoptions.contains("color")
        trackingOptions.sound = levelInfo.trackingoptions.contains("sound")

        
        level = Level(changes: changesOptions, tracking: trackingOptions, Numback: levelInfo.numback, Duration: levelInfo.duration, ISI: levelInfo.ISI, gridAppearance: levelInfo.gridAppearance, Trials: levelInfo.trials, Title: levelInfo.title)
    }
}


