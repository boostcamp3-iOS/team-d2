//
//  Subject.swift
//  team-d2
//
//  Created by Gaon Kim on 23/01/2019.
//  Copyright © 2019 boostcamp. All rights reserved.
//

import Foundation

struct Information: Codable {
    let day: String
    let time: String
    let building: String
}

struct Subject: Codable {
    let academicNumber, classNumber, courseTitle, courseDivision: String
    let domain, department, grade, professorName, score: String
    let information, englishClass, originalClass, onlineClass: String
    let limitPersonal, remark: String
    
    lazy var informations: [Information] = {
        return createInformations()
    }()
    
    enum CodingKeys: String, CodingKey {
        case academicNumber = "academic_number"
        case classNumber = "class_number"
        case courseTitle = "course_title"
        case courseDivision = "course_division"
        case domain, department, grade
        case professorName = "professor_name"
        case score, information
        case englishClass = "english_class"
        case originalClass = "original_class"
        case onlineClass = "online_class"
        case limitPersonal = "limit_personal"
        case remark
    }
    
    func createInformations() -> [Information] {
        var list: [Information] = []
        let regex = try? NSRegularExpression(pattern: "\\(.*\\)", options: [])
        let informationString = regex?.stringByReplacingMatches(in: information,
                                                                options: [],
                                                                range: NSRange(location: 0, length: information.count),
                                                                withTemplate: "")
        guard let splittedInformation = informationString?.split(separator: " ").map(String.init),
            splittedInformation.count > 1 else { return [] }
        
        var index = 0
        while index < splittedInformation.count {
            let information = Information(day: splittedInformation[index],
                                          time: splittedInformation[index + 1],
                                          building: splittedInformation[index + 2])
            
            list.append(information)
            index += 3
        }
        
        return list
    }
}
