//
//  CustomerTypeActionSheet.swift
//  fly-shop
//
//  Created by Olga Covaliova on 20.10.2025.
//

import SwiftUI

// This struct encapsulates the logic for creating ActionSheets that allow users to select from available customer types
struct CustomerTypeActionSheet {
    let customerTypes: [CustomerType]
    let onCustomerTypeChange: (CustomerType) -> Void
    
    // Creates an ActionSheet with customer type selection options
    func createActionSheet() -> ActionSheet {
        ActionSheet(
            title: Text(ProductListConstants.paymentActionSheetTitle),
            buttons: actionSheetButtons
        )
    }
    
    private var actionSheetButtons: [ActionSheet.Button] {
        let customerTypeButtons = customerTypes.map { customerType in
            ActionSheet.Button.default(Text(customerType.name)) {
                onCustomerTypeChange(customerType)
            }
        }
        
        // Add cancel button to the end of the button array
        return customerTypeButtons + [.cancel(Text(ProductListConstants.paymentActionSheetCancel))]
    }
}

// MARK: - View Extension for ActionSheet

extension CustomerTypeActionSheet {
    var actionSheet: ActionSheet {
        createActionSheet()
    }
}
