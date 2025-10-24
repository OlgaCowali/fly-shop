//
//  EmptyStateView.swift
//  fly-shop
//
//  Created by Olga Covaliova on 23.10.2025.
//

import SwiftUI

// A common view that displays when there's no data to show
// Shows a centered message to inform the user that the list is empty
struct EmptyStateView: View {
    let message: String
    let font: Font
    let textColor: Color
    
    init(
        message: String,
        font: Font = CommonConstants.emptyStateFont,
        textColor: Color = CommonConstants.emptyStateTextColor
    ) {
        self.message = message
        self.font = font
        self.textColor = textColor
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(message)
                .font(font)
                .foregroundColor(textColor)
            
            Spacer()
        }
    }
}
