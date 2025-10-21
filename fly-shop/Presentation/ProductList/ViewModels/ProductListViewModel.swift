//
//  ProductListViewModel.swift
//  fly-shop
//
//  Created by Olga Covaliova on 17.10.2025.
//

import Foundation
import SwiftUI

@MainActor
final class ProductListViewModel: ObservableObject {
    // MARK: - View State
    enum ViewState: Equatable {
        case loading
        case loaded
        case error(DomainError)
    }
    // MARK: - Published Properties
    @Published var products: [Product] = []
    @Published private(set) var categories: [Category] = []
    @Published private(set) var customerTypes: [CustomerType] = []
    @Published private(set) var selectedCategory: Category?
    @Published private(set) var selectedCustomerType: CustomerType?
    @Published private(set) var state: ViewState = .loading
    
    // MARK: - Dependencies
    private let getProductListUseCase: GetProductList
    private let getCategoriesUseCase: GetCategories
    private let getCustomerTypesUseCase: GetCustomerTypes
    
    // MARK: - Task Management
    private var loadTask: Task<Void, Never>?
    
    // MARK: - Initialization
    init(
        getProductListUseCase: GetProductList,
        getCategoriesUseCase: GetCategories,
        getCustomerTypesUseCase: GetCustomerTypes
    ) {
        self.getProductListUseCase = getProductListUseCase
        self.getCategoriesUseCase = getCategoriesUseCase
        self.getCustomerTypesUseCase = getCustomerTypesUseCase
    }
    
    deinit {
        loadTask?.cancel()
    }
    
    // MARK: - Public Methods
    
    func loadInitialData() async {
        cancelLoad()
        state = .loading
        
        async let customerTypesResult = getCustomerTypesUseCase.execute()
        async let categoriesResult = getCategoriesUseCase.execute()
        
        guard handleCustomerTypesResult(await customerTypesResult) else { return }
        guard handleCategoriesResult(await categoriesResult) else { return }
        
        await loadProducts()
    }
    
    func loadProducts() async {
        guard let customerType = selectedCustomerType else { return }
        state = .loading
        let result = await getProductListUseCase.execute(
            for: customerType,
            filteredBy: selectedCategory
        )
        switch result {
        case .success(let products):
            self.products = products
            self.state = .loaded
        case .failure(let error):
            self.state = .error(error)
        }
    }
    
    func selectCategory(_ category: Category?) {
        selectedCategory = category
        cancelLoad()
        loadTask = Task { [weak self] in
            await self?.loadProducts()
        }
    }
    
    func selectCustomerType(_ customerType: CustomerType) {
        selectedCustomerType = customerType
        cancelLoad()
        loadTask = Task { [weak self] in
            await self?.loadProducts()
        }
    }
    
    // MARK: - Private Methods
    
    private func handleCustomerTypesResult(_ result: Result<[CustomerType], DomainError>) -> Bool {
        switch result {
        case .success(let types):
            self.customerTypes = types
            if selectedCustomerType == nil {
                selectedCustomerType = defaultCustomerType(from: types)
            }
            return true
        case .failure(let error):
            self.state = .error(error)
            return false
        }
    }
    
    private func handleCategoriesResult(_ result: Result<[Category], DomainError>) -> Bool {
        switch result {
        case .success(let categories):
            self.categories = categories
            return true
        case .failure(let error):
            self.state = .error(error)
            return false
        }
    }
    
    private func defaultCustomerType(from types: [CustomerType]) -> CustomerType? {
        types.first { $0.isDefault } ?? types.first
    }
    
    private func cancelLoad() {
        loadTask?.cancel()
        loadTask = nil
    }
}
