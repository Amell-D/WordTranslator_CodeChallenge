//
//  LocalRepositoryManager.swift
//  CodeChallengeWordTranslator
//
//  Created by Air  017 on 25. 6. 2022..
//

import Foundation

protocol LocalRepositoryManagerProtocol {
    func parse(jsonData: Data)
    func getWordPairs(from file: String) -> [WordPair]
}

final class LocalRepositoryManager: LocalRepositoryManagerProtocol {
    private let localRepository: LocalRepositoryProtocol
    private var wordPairs: [WordPair] = []
    
    init(localRepository: LocalRepositoryProtocol = LocalRepository()) {
        self.localRepository = localRepository
    }
    
    func parse(jsonData: Data) {
        do {
            let decodedData = try JSONDecoder().decode([WordPair].self, from: jsonData)
            wordPairs = decodedData
        } catch {
            print("Error is: \(error)")
        }
    }
    
    func getWordPairs(from file: String) -> [WordPair] {
        guard let localFile = localRepository.readLocalFile(forName: file) else {
            return []
        }
        parse(jsonData: localFile)
        return wordPairs
    }
}
