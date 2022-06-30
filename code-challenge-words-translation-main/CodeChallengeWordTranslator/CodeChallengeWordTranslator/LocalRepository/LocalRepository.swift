//
//  LocalRepository.swift
//  CodeChallengeWordTranslator
//
//  Created by Air  017 on 25. 6. 2022..
//

import Foundation

protocol LocalRepositoryProtocol {
    func readLocalFile(forName fileName: String) -> Data?
}

final class LocalRepository: LocalRepositoryProtocol {
    enum JSONError: Error {
        case cannotReadLocalFile
    }
    
    func readLocalFile(forName fileName: String) -> Data? {
        do {
            guard
                let bundlePath = Bundle.main.path(forResource: fileName, ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) else {
                throw JSONError.cannotReadLocalFile
            }
            return jsonData
        } catch {
            return nil
        }
    }
}
