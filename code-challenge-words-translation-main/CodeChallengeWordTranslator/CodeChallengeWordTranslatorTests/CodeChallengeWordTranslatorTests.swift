//
//  CodeChallengeWordTranslatorTests.swift
//  CodeChallengeWordTranslatorTests
//
//  Created by Air  017 on 25. 6. 2022..
//

import XCTest
@testable import CodeChallengeWordTranslator

class CodeChallengeWordTranslatorTests: XCTestCase {
    
    private var localRepositoryManager: LocalRepositoryManagerProtocol = LocalRepositoryManager()
    private var viewModel = WordTranslatorGameViewModel()

    func test_getAllWordPairs() throws {
        var allWordPairs = localRepositoryManager.getWordPairs(from: "wordsMock")
        XCTAssertEqual(allWordPairs.count, 15)
    }
    
    func test_firstWordPair() throws {
        let firstWordCorrectMock = "primary school"
        let firstWordPair = localRepositoryManager.getWordPairs(from: "wordsMock").first
        XCTAssertEqual(firstWordPair?.originalWord ?? String(), firstWordCorrectMock)
        XCTAssertEqual(firstWordPair?.translatedWord ?? String(), firstWordCorrectMock)
    }
    
    func test_fulfilledConditionForEndingGame() throws {
        viewModel.wrongAttempts = 3
        XCTAssertFalse(viewModel.isPresented)
        viewModel.endGame()
        XCTAssert(viewModel.isPresented)
    }
    
    func test_unfulfilledConditionForEndingGame() throws {
        XCTAssertFalse(viewModel.isPresented)
        viewModel.endGame()
        XCTAssertFalse(viewModel.isPresented)
    }
    
    func test_timerIncrementWrongAttempts() throws {
        viewModel.startTimer()
        DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
            XCTAssertEqual(self.viewModel.wrongAttempts, 3)
        }
    }
}
