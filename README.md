# Fly Shop 

A modern iOS e-commerce application for a fly shop, built with SwiftUI and Clean Architecture principles.

## Project Overview

Fly Shop is a fully-featured e-commerce application that allows users to browse products, filter by categories and customer types, manage a shopping cart, and process payments through multiple payment methods (cash and card).

##  Project Setup

### Prerequisites

- **macOS**: Sonoma 14.0 or later
- **Xcode**: 16.0 or later
- **iOS Deployment Target**: iOS 18.5+
- **Swift**: 5.9+

### Dependencies

The project uses Swift Package Manager (SPM) for dependency management. Dependencies are automatically resolved by Xcode and include:

- **Alamofire**: Network communication layer with retry policies

### Installation & Running

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd fly-shop
   ```

2. **Open the project**:
   ```bash
   open fly-shop.xcodeproj
   ```

3. **Wait for SPM to resolve dependencies** (Xcode will do this automatically on first open)

4. **Select a simulator**:
   - Minimum supported: iOS 18.5
   - Recommended: iPhone 15 Pro (iOS 18.5+)

5. **Build and run**:
   - Press `Cmd + R` or click the Run button in Xcode
   - The app will launch in the selected simulator

## Project Structure

The application follows **Clean Architecture** principles with clear separation of concerns across three main layers:

#### 1. **Domain Layer** (Business Logic)
- **Pure Swift**: No framework dependencies
- **Entities**: Core business models (`Product`, `Category`, `Payment`, etc.)
- **Value Objects**: Immutable objects with validation (`CardNumber`, `CVV`, `ExpirationDate`)
- **Use Cases**: Business rules and application logic
- **Repository Interfaces**: Contracts for data access (dependency inversion)

#### 2. **Infrastructure Layer** (Data & External Services)
- **Repository Implementations**: Concrete implementations of domain interfaces
- **Data Sources**: API communication using Alamofire
- **DTOs**: Data mapping between API models and domain entities
- **HTTP Client**: Network abstraction with error handling and retry logic

#### 3. **Presentation Layer** (UI)
- **SwiftUI Views**: Declarative UI components
- **ViewModels**: MVVM pattern with `@Published` properties
- **Services**: Presentation-level services (cart state, payment coordination)

### Dependency Injection

The app uses **Composition Root** pattern with factory classes:

- `CompositionRoot`: Main DI container, single source of truth for dependencies
- `InfrastructureFactory`: Creates networking components
- `DataSourceFactory`: Creates API data sources
- `RepositoryFactory`: Creates repository implementations
- `UseCaseFactory`: Creates use case implementations
- `ViewModelFactory`: Creates view models with all dependencies

### Key Architectural Decisions

1. **MVVM in Presentation Layer**: Separation of view logic from business logic
2. **Protocol-Oriented Design**: All layers communicate through protocols (testability)
3. **Repository Pattern**: Abstraction over data sources
4. **Use Case Pattern**: Each business operation is a separate, testable unit
5. **Async/Await**: Modern Swift concurrency for network operations
6. **Result Type**: Explicit error handling throughout the app


##  Running Tests

### Running All Tests

**Via Xcode**:
1. Press `Cmd + U` to run all tests
2. Or navigate to `Product > Test` in the menu bar

### Running Specific Test Suites

In Xcode Test Navigator (`Cmd + 6`):
- Click the play button next to specific test class or method
- Right-click a test suite to run only that suite

### Test Coverage

The project includes comprehensive unit tests covering:

- ✅ **Domain Layer**: Use case business logic
- ✅ **Infrastructure Layer**: Repositories, HTTP client, data sources
- ✅ **Presentation Layer**: ViewModels and services
- ✅ **Utils**: Formatters and calculators


**Future Enhancement**: 

1. **Add Core Data or SwiftData for offline capability**

2. **Payment Gateway Integration**:
    - Card payments use a mock/test gateway
    - No real payment processing or PCI compliance considerations
    - **Future Enhancement**: Integrate with Stripe, Square, or similar

3. **Image Loading**:
    - Product images are loaded from URLs without caching
    - No placeholder images or loading states
    - **Future Enhancement**: Add image caching (SDWebImage, Kingfisher)

4. **Localization**:
    - UI strings are hardcoded in English
    - No multi-language support
    - **Future Enhancement**: Add localization for international markets

5. **Testing**:
    - UI tests are not implemented (only unit tests)
    - **Future Enhancement**: Add XCUITest suite for end-to-end testing

6. **Performance**:
    - No performance optimizations for large product catalogs
    - No pagination for product lists
    - **Future Enhancement**: Add lazy loading and pagination
7. **iOS Version Targeting**:
    - Requires iOS 18.5+, limiting device compatibility
    - **Trade-off**: Enables use of latest SwiftUI features but reduces market reach

## API Endpoints

The app connects to the following endpoints (defined in `APIConstant.swift`):

- **Base URL**: `https://api.npoint.io/25ed78fe1534f3d1d915`
- **Categories**: `https://api.npoint.io/25ed78fe1534f3d1d915/properties/categories`
- **Customer Types**: `https://api.npoint.io/25ed78fe1534f3d1d915/properties/customer_types`
- **Products**: `https://api.npoint.io/25ed78fe1534f3d1d915/data/`
- **Payment Gateway**: `https://api.npoint.io/4815e5513f92384df075`
