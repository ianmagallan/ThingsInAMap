//
//  HttpExecutorTest.swift
//  ThingsInAMapTests
//
//  Created by Ian Magallan on 30.12.22.
//

import Combine
import Foundation
@testable import ThingsInAMap
import Nimble
import XCTest

final class HttpExecutorTest: XCTestCase {
    var cancellableBag = Set<AnyCancellable>()
    var mockSession: MockSession!

    override func setUp() {
        super.setUp()
        mockSession = MockSession(
            mockData: Stub.data,
            mockResponse: Stub.response
        )
    }

    func testExecutorParsesSuccessfully() {
        // given
        let request = RequestFactory().fetchPointsOfInterest(path: "")
        let sut = HttpExecutor(session: mockSession)
        var pointsOfInterest: PointsOfInterestDTO?

        // when
        let execute: AnyPublisher<PointsOfInterestDTO, FNError> = sut.execute(request: request)

        execute.sink { _ in } receiveValue: { pointsOfInterest = $0
        }.store(in: &cancellableBag)

        // then
        expect(pointsOfInterest).toNotEventually(beNil())
    }

    func testExecutorParsingError() {
        // given
        let request = RequestFactory().fetchPointsOfInterest(path: "")
        let mockSession = MockSession(mockData: "".data(using: .utf8)!, mockResponse: Stub.response)
        let sut = HttpExecutor(session: mockSession)
        var expectedError: FNError?

        // when
        let execute: AnyPublisher<PointsOfInterestDTO, FNError> = sut.execute(request: request)

        execute.sink { result in
            guard case let .failure(error) = result else {
                return
            }
            expectedError = error
        } receiveValue: { _ in }.store(in: &cancellableBag)

        // then
        expect(expectedError).toEventually(equal(.parsing))
    }

    func testExecutorNetworkError() {
        // given
        let request = RequestFactory().fetchPointsOfInterest(path: "")
        let response = HTTPURLResponse(url: Stub.url, statusCode: 400, httpVersion: nil, headerFields: nil)!
        let mockSession = MockSession(mockData: Stub.data, mockResponse: response)
        let sut = HttpExecutor(session: mockSession)
        var expectedError: FNError?

        // when
        let execute: AnyPublisher<PointsOfInterestDTO, FNError> = sut.execute(request: request)

        execute.sink { result in
            guard case let .failure(error) = result else {
                return
            }
            expectedError = error
        } receiveValue: { _ in }.store(in: &cancellableBag)

        // then
        expect(expectedError).toEventually(equal(.network))
    }
}
