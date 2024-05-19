//
//  SceneDelegate.swift
//  PokemonDetailsTarget
//
//  Created by Davit on 20.05.24.
//

import UIKit
import PokemonDetailsUI
import ApiClient
import Shared

/// Separate Application / Target for specific feature of the app
/// Every feature can be separate application, easily composable and testable

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private let apiClient: ApiClient = {
        return ApiClient(session: URLSession.shared)
    }()
    
    private let imageClient: ApiClient = {
        return ApiClient(
            session: URLSession.shared,
            configuration: NetworkConfigurationImpl(baseURL: "raw.githubusercontent.com"),
            decoder: DataResponseDecoder()
        )
    }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let diContainer = PokemonDetailsDiContainer(apiClient: apiClient, imageLoaderRepository: makeImageLoaderRepository())
        
        window = UIWindow(windowScene: scene)
        window?.rootViewController = diContainer.makePokemonDetailsVC(for: .init(id: 1, name: "", imageUrl: nil))
        window?.makeKeyAndVisible()
    }
    
    func makePokemonDetailsDiContainer() -> PokemonDetailsDiContainer {
        return PokemonDetailsDiContainer(apiClient: apiClient, imageLoaderRepository: makeImageLoaderRepository())
    }
    
    
    func makeImageLoaderRepository() -> ImageLoaderRepository {
        return DefaultImageLoaderRepository(apiClient: imageClient)
    }

}

