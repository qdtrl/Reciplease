//
//  URLSessionFake.swift
//  Reciplease_DT_Quentin_26062023Tests
//
//  Created by Quentin Dubut-Touroul on 24/07/2023.
//

import Foundation

class MockURLProtocol: URLProtocol {
    static var mockResponse: URLResponse?
    static var mockData: Data?
    static var mockError: Error?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let response = MockURLProtocol.mockResponse {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }

        if let data = MockURLProtocol.mockData {
            client?.urlProtocol(self, didLoad: data)
        }

        if let error = MockURLProtocol.mockError {
            client?.urlProtocol(self, didFailWithError: error)
        }

        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {
        // Do nothing
    }
}
