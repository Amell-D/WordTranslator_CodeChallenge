//
//  WordTranslatorGameView.swift
//  CodeChallengeWordTranslator
//
//  Created by Air  017 on 26. 6. 2022..
//

import SwiftUI

struct WordTranslatorGameView: View {
    
    @ObservedObject private var viewModel = WordTranslatorGameViewModel()
    
    typealias Color = Constants.Colors
    
    var body: some View {
        ZStack {
            RadialGradient(
                colors: [Color.backgroundColor, Color.primaryColor],
                center: .center,
                startRadius: 200,
                endRadius: 900)
            .ignoresSafeArea()
            VStack {
                userAttemptsCounter
                Spacer()
                wordTranslator
                    .onAppear {
                        viewModel.startTimer()
                    }
                Spacer()
                usersChosenAnswer
            }
        }
        .alert(isPresented: $viewModel.isPresented) {
            endgameAlert
        }
    }
    
    private var endgameAlert: Alert {
        return Alert(title: Text("Your final score is: \(viewModel.correctAttempts)"),
                     message: Text("What would you like to do next?"),
                     primaryButton: .default(
                        Text("Restart the game"),
                        action: { viewModel.restartTheGame() }),
                     secondaryButton: .destructive(
                        Text("Quit the game"),
                        action: { viewModel.exitTheApp() }))
    }
    
    private var userAttemptsCounter: some View {
        HStack {
            Spacer()
            VStack(alignment: .trailing, spacing: 5) {
                Text("Correct attempts: \(viewModel.correctAttempts)")
                Text("Wrong attempts: \(viewModel.wrongAttempts)")
            }
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(Color.textColor)
        }
        .padding()
    }
    
    private var wordTranslator: some View {
        ZStack {
            Color.primaryColor
                .cornerRadius(10)
                .frame(height: 200)
                .padding(.horizontal)
            VStack(alignment: .center, spacing: 30) {
                Text(viewModel.translatedWord)
                    .font(.system(size: 30, weight: .semibold))
                    .offset(y: viewModel.yOffset)
                    .onAppear {
                        viewModel.startTranslatedWordAnimation()
                    }
                    .onChange(of: viewModel.translatedWord, perform: { _ in
                        viewModel.startTranslatedWordAnimation()
                    })
                Text(viewModel.originalWord)
                    .font(.system(size: 22, weight: .semibold))
            }
            .multilineTextAlignment(.center)
            .padding(20)
            .foregroundColor(Color.textColor)
        }
    }
    
    private var usersChosenAnswer: some View {
        HStack(spacing: 30) {
            PrimaryButton(textLabel: "Correct") {
                viewModel.checkForCorrectAnswer()
                viewModel.startTimer(shouldStopPreviousInstance: true)
            }
            PrimaryButton(textLabel: "Wrong") {
                viewModel.checkForWrongAnswer()
                viewModel.startTimer(shouldStopPreviousInstance: true)
            }
        }
    }
}

