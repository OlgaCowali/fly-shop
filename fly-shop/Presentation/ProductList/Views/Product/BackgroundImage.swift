//
//  BackgroundImage.swift
//  fly-shop
//
//  Created by Olga Covaliova on 20.10.2025.
//

import SwiftUI

struct BackgroundImage: View {
    let product: Product
    let size: CGSize
    
    var body: some View {
        // Async image loading with simple placeholder, scaled to fill the card bounds
        AsyncImage(url: URL(string: product.imageURL)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height)
                .clipped()
        } placeholder: {
            // Gray placeholder while image loads
            Rectangle()
                .fill(Color.gray.opacity(ProductListConstants.imagePlaceholderOpacity))
        }
    }
}
