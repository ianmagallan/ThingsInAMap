//
//  RequestFactory.swift
//  ThingsInAMap
//
//  Created by Ian Magallan on 30.12.22.
//

import Foundation

protocol RequestFactoring {
    func fetchPointsOfInterest(path: String) -> URLRequest
}

final class RequestFactory: RequestFactoring {
    private var baseURL: URL {
        guard let url = URL(string: "https://some-url-that-does-not-exist.com") else {
            fatalError("Base URL could not be created")
        }

        return url
    }

    func fetchPointsOfInterest(path: String) -> URLRequest {
        let urlString = baseURL.absoluteString + path
        guard let url = URL(string: urlString) else {
            preconditionFailure("URL could not be created")
        }
        return URLRequest(url: url)
    }
}
