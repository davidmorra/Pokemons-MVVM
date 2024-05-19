import Foundation
import Combine

/*
 Another option is to have an ApiClient with async/await
 -  func perform(_ request: URLRequest) async throws -> T
 and in the viewmodel use @Published or Subject for binding.
 */

public protocol URLSessionProtocol {
    func publisher(for request: URLRequest) -> AnyPublisher<(data: Data, response: HTTPURLResponse), Error>
}

extension URLSession: URLSessionProtocol {
    public func publisher(for request: URLRequest) -> AnyPublisher<(data: Data, response: HTTPURLResponse), Error> {
        return dataTaskPublisher(for: request)
            .tryMap { (data: Data, response: URLResponse) in
                guard let httpResponse = (response as? HTTPURLResponse) else {
                    throw NetworkError.invalidResponse
                }
                
                return (data, httpResponse)
            }
            .eraseToAnyPublisher()
    }
}

public class ApiClient {
    private let session: URLSessionProtocol
    private let configuration: NetworkConfiguration
    private let decoder: ResponseDecoding
    
    public init(
        session: URLSessionProtocol,
        configuration: NetworkConfiguration = NetworkConfigurationImpl.default,
        decoder: ResponseDecoding = ResponseDecoder()
    ) {
        self.session = session
        self.configuration = configuration
        self.decoder = decoder
    }
    
    public func perform<T: Decodable, R: Requestable>(_ request: R) -> AnyPublisher<T, Error> {
        guard let urlRequest = request.makeURLRequest(from: configuration) else {
            return Fail(error: NetworkError.badRequest)
                .eraseToAnyPublisher()
        }
        
        return session.publisher(for: urlRequest)
            .responseData()
            .tryMap { data -> T in
                try self.decoder.decode(T.self, from: data)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

public enum NetworkError: Error {
    case badRequest
    case invalidResponse
    case decodeError
}

struct AnyCodingKey: CodingKey {
    let stringValue: String
    let intValue: Int?
    
    init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }
    
    init?(intValue: Int) {
        self.intValue = intValue
        self.stringValue = "\(intValue)"
    }
}

public extension JSONDecoder.KeyDecodingStrategy {
    static var convertFromAnyCase: JSONDecoder.KeyDecodingStrategy = .custom({ keys in
        let codingKey = keys.last!
        let key = codingKey.stringValue
        
        guard key.contains("-") else {
            let words = key.components(separatedBy: "_")
            let camelCased = words[0] +
            words[1...].map(\.capitalized).joined()
            
            return AnyCodingKey(stringValue: camelCased)!
        }
        
        let words = key.components(separatedBy: "-")
        let camelCased = words[0] +
        words[1...].map(\.capitalized).joined()
        
        return AnyCodingKey(stringValue: camelCased)!
    })
}

public extension Publisher 
where Output == (data: Data, response: HTTPURLResponse), Failure == Error {
    
    func responseData() -> AnyPublisher<Data, Error> {
        tryMap { (data: Data, response: HTTPURLResponse) -> Data in
            switch response.statusCode {
            case 200...299: return data
            default:
                throw NetworkError.invalidResponse
            }
        }
        .mapError { $0 as! NetworkError }
        .eraseToAnyPublisher()
    }
}
