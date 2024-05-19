import Foundation
import Combine
import ApiClient

public protocol ImageLoaderRepository {
    func loadImage(for pokemonId: Int) -> AnyPublisher<Data, Error>
    func loadImage(path: String) -> AnyPublisher<Data, Error>
}

public class DefaultImageLoaderRepository: ImageLoaderRepository {
    private let apiClient: ApiClient

    public init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }
    
    public func loadImage(for pokemonId: Int) -> AnyPublisher<Data, Error> {
        let request = ImageAPI.imageFor(pokemonId)
        return apiClient.perform(request)
    }
    
    public func loadImage(path: String) -> AnyPublisher<Data, Error> {
        let request = ImageAPI.path(path)
        return apiClient.perform(request)
    }
}
