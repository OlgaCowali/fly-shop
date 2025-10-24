//
//  SeatSectionView.swift
//  fly-shop
//
//  Created by Olga Covaliova on 20.10.2025.
//

import SwiftUI

// View displaying the seat number with a dropdown for seat selection
struct SeatSectionView: View {
    @Binding var selectedSeat: String
    @State private var isDropdownExpanded = false
    
    // Generate all possible seat combinations by combining rows and numbers
    private var availableSeats: [String] {
        var seats: [String] = []
        for row in CartConstants.seatRows {
            for number in CartConstants.seatNumbers {
                seats.append("\(row) \(number)")
            }
        }
        return seats
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: CartConstants.seatSectionSpacing) {
            seatLabelView
            seatDropdownView
        }
    }
    
    // MARK: - Sub-views
    
    // Label text for the seat section
    private var seatLabelView: some View {
        Text(CartConstants.seatLabel)
            .font(CartConstants.labelFont)
            .fontWeight(CartConstants.labelFontWeight)
            .foregroundColor(.secondary)
    }
    
    // Container for the dropdown button and list
    private var seatDropdownView: some View {
        VStack(alignment: .leading, spacing: 0) {
            seatSelectionButton
            dropdownListView
        }
    }
    
    // Button that shows current seat and toggles dropdown
    private var seatSelectionButton: some View {
        Button(action: toggleDropdown) {
            seatButtonContent
        }
        .background(seatButtonBackground)
    }
    
    // Content inside the seat selection button
    private var seatButtonContent: some View {
        Text(selectedSeat)
            .font(CartConstants.seatNumberFont)
            .fontWeight(CartConstants.seatNumberFontWeight)
            .foregroundColor(.primary)
            .padding(.horizontal, CartConstants.seatButtonHorizontalPadding)
            .padding(.vertical, CartConstants.seatButtonVerticalPadding)
    }
    
    // Background styling for the seat selection button
    private var seatButtonBackground: some View {
        RoundedRectangle(cornerRadius: CartConstants.seatCornerRadius)
            .fill(Color.gray.opacity(CartConstants.seatBackgroundOpacity))
            .frame(width: CartConstants.seatFrameWidth, height: CartConstants.seatFrameHeight)
    }
    
    // Conditionally displayed dropdown list with animation
    @ViewBuilder
    private var dropdownListView: some View {
        if isDropdownExpanded {
            HStack {
                dropdownScrollView
                    .frame(width: CartConstants.seatFrameWidth)
                    .frame(maxHeight: CartConstants.dropdownMaxHeight)
                    .background(dropdownBackground)
                    .transition(.opacity.combined(with: .scale(scale: CartConstants.dropdownAnimationScale)))
                
                Spacer()
            }
        }
    }
    
    // Scrollable list of all available seat options
    private var dropdownScrollView: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(availableSeats, id: \.self) { seat in
                    createSeatOptionButton(for: seat)
                }
            }
        }
    }
    
    // Styled background for the dropdown list with shadow
    private var dropdownBackground: some View {
        RoundedRectangle(cornerRadius: CartConstants.dropdownCornerRadius)
            .fill(Color(.systemBackground).opacity(CartConstants.dropdownBackgroundOpacity))
            .shadow(
                color: CartConstants.dropdownShadowColor.opacity(CartConstants.dropdownShadowOpacity),
                radius: CartConstants.dropdownShadowRadius,
                x: CartConstants.dropdownShadowOffsetX,
                y: CartConstants.dropdownShadowOffsetY
            )
    }
    
    // Individual seat option button in the dropdown
    private func createSeatOptionButton(for seat: String) -> some View {
        Button(action: { selectSeat(seat) }) {
            createSeatOptionContent(for: seat)
        }
        .background(createSeatOptionBackground(for: seat))
    }
    
    // Content styling for each seat option in the dropdown
    private func createSeatOptionContent(for seat: String) -> some View {
        HStack {
            Text(seat)
                .font(CartConstants.seatNumberFont)
                .fontWeight(CartConstants.seatNumberFontWeight)
                .foregroundColor(.primary)
        }
        .padding(.horizontal, CartConstants.seatOptionHorizontalPadding)
        .padding(.vertical, CartConstants.seatOptionVerticalPadding)
        .frame(height: CartConstants.dropdownItemHeight)
    }
    
    // Background highlighting for selected seat option
    private func createSeatOptionBackground(for seat: String) -> some View {
        RoundedRectangle(cornerRadius: CartConstants.dropdownCornerRadius)
            .fill(selectedSeat == seat ? CartConstants.selectedSeatBackgroundColor : Color.clear)
    }
    
    // MARK: - Actions
    
    // Toggle dropdown visibility with animation
    private func toggleDropdown() {
        withAnimation(.easeInOut(duration: CartConstants.dropdownAnimationDuration)) {
            isDropdownExpanded.toggle()
        }
    }
    
    // Select a seat and close the dropdown with animation
    private func selectSeat(_ seat: String) {
        selectedSeat = seat
        withAnimation(.easeInOut(duration: CartConstants.dropdownAnimationDuration)) {
            isDropdownExpanded = false
        }
    }
}
