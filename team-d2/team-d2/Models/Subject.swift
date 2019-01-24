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

struct Subject {
    let academicNumber, classNumber, courseTitle, courseDivision: String
    let domain, department, grade, professorName, score: String
    let information, englishClass, originalClass, onlineClass: String
    let limitPersonal, remark: String
    
    var informations: [Information] = []
    
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
}

extension Subject: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        academicNumber = try values.decode(String.self, forKey: .academicNumber)
        classNumber = try values.decode(String.self, forKey: .classNumber)
        courseTitle = try values.decode(String.self, forKey: .courseTitle)
        courseDivision = try values.decode(String.self, forKey: .courseDivision)
        domain = try values.decode(String.self, forKey: .domain)
        department = try values.decode(String.self, forKey: .department)
        grade = try values.decode(String.self, forKey: .grade)
        professorName = try values.decode(String.self, forKey: .professorName)
        score = try values.decode(String.self, forKey: .score)
        information = try values.decode(String.self, forKey: .information)
        englishClass = try values.decode(String.self, forKey: .englishClass)
        originalClass = try values.decode(String.self, forKey: .originalClass)
        onlineClass = try values.decode(String.self, forKey: .onlineClass)
        limitPersonal = try values.decode(String.self, forKey: .limitPersonal)
        remark = try values.decode(String.self, forKey: .remark)
        informations = createInformations()
    }
    
    private func splitInformation() -> [String] {
        let regex = try? NSRegularExpression(pattern: "\\(.*\\)", options: [])
        let replacedInformation = regex?.stringByReplacingMatches(in: information,
                                                                  options: [],
                                                                  range: NSRange(location: 0, length: information.count),
                                                                  withTemplate: "")
        guard let splittedInformation = replacedInformation?.split(separator: " ").map(String.init) else { return [] }
        
        return splittedInformation
    }
    
    private func createInformations() -> [Information] {
        var informations: [Information] = []
        let splittedInformation = splitInformation()
        var index = 0
        while index + 2 < splittedInformation.count {
            let information = Information(day: splittedInformation[index],
                                          time: splittedInformation[index + 1],
                                          building: splittedInformation[index + 2])
            
            informations.append(information)
            index += 3
        }
        
        return informations
    }
}
