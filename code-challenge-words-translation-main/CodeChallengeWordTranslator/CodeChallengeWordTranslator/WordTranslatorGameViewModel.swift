//
//  WordTranslatorGameViewModel.swift
//  CodeChallengeWordTranslator
//
//  Created by Air  017 on 25. 6. 2022..
//

import Foundation
import SwiftUI

final class WordTranslatorGameViewModel: ObservableObject {
    private let localRepositoryManager: LocalRepositoryManagerProtocol
    
    private var allWordPairs: [WordPair] = []
    private var randomChosenWordPair = WordPair(originalWord: "", translatedWord: "")
    
    private let correctWordPairProbability = 25.0
    private var wrongWordPairProbability: Double {
        guard correctWordPairProbability < 100 else { return .zero }
        return 100.00 - correctWordPairProbability
    }
    
    private var numberOfDisplayedWordPairs = 0
    private var timer: Timer?
    
    // MARK: Published variables
    @Published var originalWord: String = String()
    @Published var translatedWord: String = String()
    @Published var yOffset: CGFloat = -300
    
    var isPresented: Bool = false
    var correctAttempts: Int = 0
    var wrongAttempts: Int = 0
    
    init(localRepositoryManager: LocalRepositoryManagerProtocol = LocalRepositoryManager()) {
        self.localRepositoryManager = localRepositoryManager
        self.allWordPairs = localRepositoryManager.getWordPairs(from: Constants.localData)
        setupNewWordPair()
    }
    
    // MARK: Picking word pair
    private func pickCorrectWordPair() -> WordPair? {
        return allWordPairs.randomElement()
    }
    
    private func pickWrongWordPair() -> WordPair? {
        guard let originalWord = allWordPairs.randomElement()?.originalWord else { return nil }
        let filteredAllWordPairs = allWordPairs.filter { $0.originalWord != originalWord }
        
        guard let translatedWord = filteredAllWordPairs.randomElement()?.translatedWord else { return nil }
        return WordPair(originalWord: originalWord, translatedWord: translatedWord)
    }
    
    private func weightedRandomWordPair(correctWordPair: WeightedWordPair, wrongWordPair: WeightedWordPair) -> WordPair? {
        let random = Double.random(in: 0.0...100.0)
        var accumulatedWeight = 0.0
        var isCorrectWordPair = true
        let sumOfWeightedWordPairs: [WeightedWordPair] = [correctWordPair, wrongWordPair]
        
        for weightedWordPair in sumOfWeightedWordPairs {
            guard
                let originalWord = weightedWordPair.wordPair?.originalWord,
                let translatedWord = weightedWordPair.wordPair?.translatedWord
            else {
                return WordPair(originalWord: "", translatedWord: "")
            }
            accumulatedWeight += weightedWordPair.weight
            
            if random <= accumulatedWeight {
                return WordPair(originalWord: originalWord, translatedWord: translatedWord, isCorrectWordPair: isCorrectWordPair)
            } else {
                isCorrectWordPair.toggle()
            }
        }
        return sumOfWeightedWordPairs.last?.wordPair
    }
    
    private func chooseRandomWordPair() {
        guard let chosenWordPair = weightedRandomWordPair(
            correctWordPair: WeightedWordPair(wordPair: pickCorrectWordPair(), weight: correctWordPairProbability),
            wrongWordPair: WeightedWordPair(wordPair: pickWrongWordPair(), weight: wrongWordPairProbability)) else {
            return
        }
        
        randomChosenWordPair = chosenWordPair
        numberOfDisplayedWordPairs += 1
    }
    
    private func displayWordPair(chosenWordPair: WordPair?) {
        guard
            let tempOriginalWord = chosenWordPair?.originalWord,
            let tempTranslatedWord = chosenWordPair?.translatedWord
        else { return }
        
        originalWord = tempOriginalWord.localizedCapitalized
        translatedWord = tempTranslatedWord.localizedCapitalized
    }
    
    private func setupNewWordPair() {
        toggleEndgameAlert()
        chooseRandomWordPair()
        displayWordPair(chosenWordPair: randomChosenWordPair)
    }
    
    // MARK: Checking user's answers
    func checkForWrongAnswer() {
        if randomChosenWordPair.isCorrectWordPair {
            wrongAttempts += 1
        } else {
            correctAttempts += 1
        }
        setupNewWordPair()
    }
    
    func checkForCorrectAnswer() {
        if randomChosenWordPair.isCorrectWordPair {
            correctAttempts += 1
        } else {
            wrongAttempts += 1
        }
        setupNewWordPair()
    }
    
    // MARK: Timer
    func startTimer(shouldStopPreviousInstance: Bool = false) {
        if shouldStopPreviousInstance {
            timer?.invalidate()
        }
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            self.wrongAttempts += 1
            self.setupNewWordPair()
        })
    }
    
    // MARK: Ending the game
    private func toggleEndgameAlert() {
        if wrongAttempts >= 3 || numberOfDisplayedWordPairs >= 15 {
            timer?.invalidate()
            isPresented = true
        }
    }
    
    func restartTheGame() {
        resetAttemptCounters()
        setupNewWordPair()
    }
    
    private func resetAttemptCounters() {
        correctAttempts = 0
        wrongAttempts = 0
    }
    
    func exitTheApp() {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
    }
    
    // MARK: Animations
    func startTranslatedWordAnimation() {
        yOffset = -300
        withAnimation(.easeInOut(duration: 0.5)) {
            yOffset = 0
        }
    }
}

