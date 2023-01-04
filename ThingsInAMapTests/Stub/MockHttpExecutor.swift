//
//  MockHttpExecutor.swift
//  ThingsInAMapTests
//
//  Created by Ian Magallan on 31.12.22.
//

import Combine
import Foundation
@testable import ThingsInAMap

final class MockHttpExecutor: HttpExecuting {
    var stubbedData: Data?
    var stubbedError: FNError?
    func execute<T: Decodable>(request _: URLRequest) -> AnyPublisher<T, FNError> {
        let result: Result<T, FNError>
        if let stubbedData {
            result = .success(try! JSONDecoder().decode(T.self, from: stubbedData))
        } else if let stubbedError {
            result = .failure(stubbedError)
        } else {
            fatalError("Either data or error need to be set")
        }
        return result.publisher.eraseToAnyPublisher()
    }
}
