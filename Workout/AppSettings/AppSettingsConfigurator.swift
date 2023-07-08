//
//  
//  AppSettingsConfigurator.swift
//  Workout
//
//  Created by Salvador on 7/7/23.
//
//
import CoreData

final class AppSettingsConfigurator {
    static func injectDependencies(view: AppSettingsPresenterToViewProtocol,
                                   interactor: AppSettingsPresenterToInteractorProtocol,
                                   presenter: AppSettingsPresenter,
                                   router: AppSettingsPresenterToRouterProtocol) {
        presenter.interactor = interactor
        interactor.presenter = presenter

        view.presenter = presenter
        presenter.viewAppSettings = view
        
        router.presenter = presenter
        presenter.router = router
    }
    
    static func resolveFor(managedObjectContext: NSManagedObjectContext) -> AppSettingsPresenter {
        let presenter = AppSettingsPresenter()
        let view = AppSettingsView()
        let interactor = AppSettingsInteractor(managedObjectContext: managedObjectContext)
        let router = AppSettingsRouter()

        Self.injectDependencies(view: view,
                                interactor: interactor,
                                presenter: presenter,
                                router: router)

        return presenter
    }
}
