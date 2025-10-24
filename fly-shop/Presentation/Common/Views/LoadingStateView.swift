//
//  LoadingStateView.swift
//  fly-shop
//
//  Created by Olga Covaliova on 23.10.2025.
//

import SwiftUI

// A common view that displays while data is being loaded
// Shows a loading indicator with customizable text
struct LoadingStateView: View {
    let loadingText: String
    let spacing: CGFloat
    let padding: CGFloat
    let indicatorColor: Color
    let indicatorScale: CGFloat
    let textFont: Font
    let textColor: Color
    
    var body: some View {
        VStack(spacing: spacing) {
            Spacer()
            
            // Loading indicator
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: indicatorColor))
                .scaleEffect(indicatorScale)
            
            // Loading text
            Text(loadingText)
                .font(textFont)
                .foregroundColor(textColor)
            
            Spacer()
        }
        .padding(padding)
    }
}
