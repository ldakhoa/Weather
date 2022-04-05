//
//  APIEndpont.swift
//  Weather
//
//  Created by Khoa Le on 05/04/2022.
//

import Foundation

public typealias Parameters = [String: Any]
public typealias HTTPHeaders = [String: String]

/// The HTTP request methods of the receiver.
public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

/// A definition of an valid endpoint to create a URLRequest.
public protocol APIEndpoint {
    /// The base URL path.
    var baseURLPath: String { get }

    /// The path component to the URL.
    var path: String { get }

    /// HTTP Headers.
    ///
    /// Key: The value for the header field.
    ///
    /// Value: The name of the header field. In keeping with the HTTP RFC, HTTP header field names are case insensitive.
    var headers: HTTPHeaders { get }

    /// A single name-value pair from the query portion of a URL.
    var parameters: Parameters? { get }

    /// The HTTP request method.
    var method: HTTPMethod { get }

    /// An object that decodes instances of a data type from JSON objects.
    var jsonDecoder: JSONDecoder { get }
}

// MARK: - Public APIEndpoint
public extension APIEndpoint {
    var baseURLPath: String {
        DefaultNetworkConfiguration.makeBaseURL()
    }

    var headers: HTTPHeaders {
        [
            "Content-Type": "application/json",
        ]
    }

    var jsonDecoder: JSONDecoder {
        JSONDecoder()
    }

    /// Build an URLRequest from provided endpoint properties.
    /// - Returns: An URLRequest.
    func buildRequest() -> URLRequest? {
        guard let url = urlComponents?.url else { return nil }
        var request = URLRequest(
            url: url,
            timeoutInterval: 10)
        request.httpMethod = method.rawValue
        request.httpBody = parametersToHttpBody()
        request.timeoutInterval = 5 * 1000
        headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        return request
    }
}

// MARK: - Private
private extension APIEndpoint {
    /// A computed `URLComponents` property as a combination of `baseURLPath` and `path`.
    var urlComponents: URLComponents? {
        guard var url = URL(string: baseURLPath) else { return nil }
        url.appendPathComponent(path)

        var urlCompontens = URLComponents(url: url, resolvingAgainstBaseURL: false)

        // Specific support for GET method
        if method == .get {
            let queryParams = parametersAsURLQueryItems()
            if !queryParams.isEmpty {
                urlCompontens?.queryItems = queryParams
            }
        }

        return urlCompontens
    }

    /// Converts a JSON object into Data to use as the HTTPBody.
    /// - Returns: The converted data.
    func parametersToHttpBody() -> Data? {
        guard let params = parameters,
              method != .get else {
            return nil
        }
        return try? JSONSerialization.data(withJSONObject: params, options: [])
    }

    /// Converts a JSON object to URLQueryItem.
    /// - Returns: A URLQueryItem.
    func parametersAsURLQueryItems() -> [URLQueryItem] {
        var items = [URLQueryItem]()

        for (key, value) in parameters ?? [:] {
            items.append(URLQueryItem(name: key, value: "\(value)"))
        }

        return items.filter { !$0.name.isEmpty }
    }
}
