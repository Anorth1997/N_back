//
//  CustomizedLevelData.swift
//  N_back
//
//  Created by Ziyao. Chen on 2018-07-31.
//  Copyright © 2018 TalentedExplorer. All rights reserved.
//

import Foundation


// This is the serialized data form of a customized level
struct CustomizedLevel: Codable {
    var changesoptions: [String]
    var trackingoptions : [String]
    var numback: Int
    var trials: Int
    var duration: Double
    var title: String
    var ISI: Double
    var gridAppearance: Bool
    
    private enum CodingKeys : String, CodingKey {
        case changesoptions = "changesoptions"
        case trackingoptions = "trackingoptions"
        case numback = "numback"
        case trials = "trials"
        case duration = "duration"
        case title = "title"
        case ISI = "ISI"
        case gridAppearance = "gridAppearance"
    }
}

//extension CustomizedLevel: Decodable {
//    init(decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        changesoptions = try values.decode([String].self, forKey: "changesoptions")
//        trackingoptions = try values.decode([String].self, forKey: "trackingoptions")
//        numback = try values.decode(Int.self, forKey: "numback")
//        trials = try value.decode(Int.self, forKey: "trials")
//        duration = try value.decode(Double.self, forKey: "duration")
//        title = try value.decode(String.self, forKey: "title")
//    }
//}

