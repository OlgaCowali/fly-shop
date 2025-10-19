//
//  CompositionRoot.swift
//  fly-shop
//
//  Created by Olga Covaliova on 17.10.2025.
//

import Foundation
import SwiftUI

// Main dependency injection container that orchestrates the creation of all app dependencies
final class CompositionRoot: ObservableObject {
    
    init() {}
    
    // Creates and returns a configured ProductListViewModel with all required dependencies
    @MainActor func makeProductListViewModel() -> ProductListViewModel {
        viewModelFactory.makeProductListViewModel()
    }
    
    // MARK: - Factories
    
    // Factory for creating infrastructure components (HTTP client, etc.)
    private lazy var infrastructureFactory = InfrastructureFactory()
    
    // Factory for creating data source implementations
    private lazy var dataSourceFactory = DataSourceFactory(httpClient: infrastructureFactory.makeHTTPClient())
    
    // Factory for creating repository implementations
    private lazy var repositoryFactory = RepositoryFactory(dataSources: dataSourceFactory.makeProductListDataSources())
    
    // Factory for creating use case implementations
    private lazy var useCaseFactory = UseCaseFactory(repositories: repositoryFactory.makeProductListRepositories())
    
    // Factory for creating view model implementations
    private lazy var viewModelFactory = ViewModelFactory(useCases: useCaseFactory.makeProductListUseCases())
}
