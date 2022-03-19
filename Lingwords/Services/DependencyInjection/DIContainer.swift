//
//  DIContainer.swift
//  Lingwords
//
//  Created by Daniil Kostitsin on 08.03.2022.
//

import Foundation

/// Set of methods that dependency injection services should implement
public protocol DIContainerProtocol {

    /// Registers component for specified type
    /// - Parameters:
    ///   - type: type for which the component should be registered
    ///   - component: component instance
    func register<Component>(type: Component.Type, component: Any)

    /// Return component that was previously registered for specified type
    /// - Parameter type: component type
    /// - Returns: component that was previously registered for specified type, `nil` otherwise
    func resolve<Component>(type: Component.Type) -> Component?
}

public final class DIContainer: DIContainerProtocol {

    /// Shared dependency injection container
    public static let shared = DIContainer()

    private var components: [String: Any] = [:]

    private init() { }

    public func register<Component>(type: Component.Type, component: Any) {
        components["\(type)"] = component
    }

    public func resolve<Component>(type: Component.Type) -> Component? {
        components["\(type)"] as? Component
    }
}
