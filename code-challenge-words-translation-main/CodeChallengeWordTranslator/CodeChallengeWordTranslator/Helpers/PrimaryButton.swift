//
//  PrimaryButton.swift
//  CodeChallengeWordTranslator
//
//  Created by Air  017 on 25. 6. 2022..
//

import SwiftUI

struct PrimaryButton: View {
    
    private var textColor: Color
    private var backgroundColor: Color
    private let buttonAction: () -> Void
    @State var textLabel: String
    
    init(textColor: Color = Constants.Colors.textColor,
         backgroundColor: Color = Constants.Colors.backgroundColor,
         textLabel: String,
         buttonAction: @escaping () -> Void
    ) {
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.textLabel = textLabel
        self.buttonAction = buttonAction
    }
    
    var body: some View {
        Button(action: buttonAction) {
            Text(textLabel)
                .foregroundColor(textColor)
                .font(.system(size: 30, weight: .semibold))
                .padding()
                .background(backgroundColor)
                .cornerRadius(10)
                .shadow(radius: 10, x: CGFloat(5), y: CGFloat(5))
                .shadow(radius: 10, x: CGFloat(5), y: CGFloat(5))
        }
    }
}
