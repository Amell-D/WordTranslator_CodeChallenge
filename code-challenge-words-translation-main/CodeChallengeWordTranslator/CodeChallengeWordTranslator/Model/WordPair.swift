//
//  WordPair.swift
//  CodeChallengeWordTranslator
//
//  Created by Air  017 on 25. 6. 2022..
//

import Foundation

struct WordPair: Decodable {
    enum CodingKeys: String, CodingKey {
        case originalWord = "text_eng"
        case translatedWord = "text_spa"
    }
    
    let originalWord: String
    let translatedWord: String
    var isCorrectWordPair: Bool = false
}
