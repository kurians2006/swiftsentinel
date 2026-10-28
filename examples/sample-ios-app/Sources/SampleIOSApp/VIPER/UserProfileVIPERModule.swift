import Foundation
import SwiftUI

// MARK: - VIPER Contracts (Interface Segregation & Inversion)

public protocol UserProfileViewProtocol: AnyObject, Sendable {
    func display(user: User)
    func display(error: String)
}

public protocol UserProfilePresenterProtocol: AnyObject, Sendable {
    func viewDidLoad(userId: String) async
    func didTapSettings()
}

public protocol UserProfileInteractorProtocol: Sendable {
    func fetchUser(userId: String) async throws -> User
}

public protocol UserProfileRouterProtocol: Sendable {
    func navigateToSettings()
}

// MARK: - VIPER Implementations

public final class UserProfileInteractor: UserProfileInteractorProtocol {
    private let repository: UserReadableRepository

    public init(repository: UserReadableRepository) {
        self.repository = repository
    }

    public func fetchUser(userId: String) async throws -> User {
        return try await repository.getUser(id: userId)
    }
}

public final class UserProfilePresenter: UserProfilePresenterProtocol {
    public weak var view: UserProfileViewProtocol?
    private let interactor: UserProfileInteractorProtocol
    private let router: UserProfileRouterProtocol

    public init(interactor: UserProfileInteractorProtocol, router: UserProfileRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }

    public func viewDidLoad(userId: String) async {
        do {
            let user = try await interactor.fetchUser(userId: userId)
            await MainActor.run {
                view?.display(user: user)
            }
        } catch {
            await MainActor.run {
                view?.display(error: error.localizedDescription)
            }
        }
    }

    public func didTapSettings() {
        router.navigateToSettings()
    }
}

public final class UserProfileRouter: UserProfileRouterProtocol {
    public init() {}
    public func navigateToSettings() {
        // Handle navigation wireframe transition
    }
}
