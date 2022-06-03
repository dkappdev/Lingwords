//
//  DIContainer.swift
//  Lingwords
//
//  Created by Daniil Kostitsin on 08.03.2022.
//

import Foundation

/// Set of methods that dependency injection services should implement
protocol DIContainerProtocol {

    /// Registers component for specified type
    /// - Parameters:
    ///   - type: type for which the component should be registered
    ///   - component: component instance
    func register<Component>(type: Component.Type, component: Component)

    /// Returns component that was previously registered for specified type
    /// - Parameter type: component type
    /// - Returns: component that was previously registered for specified type, `nil` otherwise
    func resolve<Component>(type: Component.Type) -> Component?
}

/// Concrete dependency injection container implementation. This class is used to register dependencies during setup.
final class DIContainer: DIContainerProtocol {

    /// Shared dependency injection container
    static let shared = DIContainer()

    private var components: [String: Any] = [:]

    private init() { }

    func register<Component>(type: Component.Type, component: Component) {
        components["\(type)"] = component
    }

    func resolve<Component>(type: Component.Type) -> Component? {
        components["\(type)"] as? Component
    }
}
