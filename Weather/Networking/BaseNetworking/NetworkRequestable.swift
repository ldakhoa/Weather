//
//  NetworkRequestable.swift
//  Weather
//
//  Created by Khoa Le on 05/04/2022.
//

import Foundation

/// An object that responsibility of firing API call.
public protocol NetworkRequestable {
    /// Fetches a network request with a relevent `Decodable.Type` to decode the response.
    /// - Parameters:
    ///   - endPoint: The endpoint to fetch.
    ///   - type: The decode closure that expects a `Decodable` object and returns a relevant type.
    ///   - completion: The completion handler of the request.
    func fetch<T: Decodable>(
        endPoint: APIEndpoint,
        type: T.Type,
        completion: @escaping(Result<T, NetworkError>) -> Void)
}

// MARK: - NetworkClient

/// An object that responsibility of firing API call.
public struct DefaultNetworkRequestable: NetworkRequestable {

    public typealias NetworkClientResponse<T> = (Result<T, NetworkError>) -> Void

    private let session: URLSession

    /// Creates an instance of network client.
    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    public func fetch<T: Decodable>(
        endPoint: APIEndpoint,
        type: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard Reachability.isConnectedToNetwork() else {
            completion(.failure(.noInternet))
            return
        }
            
        guard let request = endPoint.buildRequest() else {
            completion(.failure(.unableToGenerateURLRequest))
            return
        }
        print(request.curlString)

        let task = session.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let response = response,
                let httpResponse = response as? HTTPURLResponse else {
                if let error = error {
                    completion(.failure(.fetchError(error: error)))
                } else {
                    // Throw invalidResponse if there is no data, http response or error
                    completion(.failure(.invalidResponse))
                }
                return
            }

            // Check the status code is in range
            guard 200..<300 ~= httpResponse.statusCode else {
                completion(.failure(.noSuccessResponse(code: "\(httpResponse.statusCode)")))
                return
            }

            self.parseData(endPoint: endPoint, data: data, completion: completion)
        }

        task.resume()
    }

    /// The step to parse Data to Object model(s).
    /// - Parameters:
    ///   - endPoint: The endpoint to fetch.
    ///   - data: The data to parse.
    ///   - completion: The completion handler of the request.
    private func parseData<T: Decodable>(
        endPoint: APIEndpoint,
        data: Data,
        completion: @escaping NetworkClientResponse<T>) {
        do {
            let genericModel = try endPoint.jsonDecoder.decode(T.self, from: data)
            completion(.success(genericModel))
        } catch {
            completion(.failure(.badDeserialization(error: error)))
        }
    }
}

// MARK: - Network Error

/// The network error.
public enum NetworkError: Error, CustomStringConvertible {
    /// Unable to generate the URL request for the given options.
    case unableToGenerateURLRequest

    /// Expected deserialization of the response failed.
    case badDeserialization(error: Error)

    /// There was an invalid response from the network
    case invalidResponse

    /// Unable to fetch with the specified underlying error.
    case fetchError(error: Error)

    /// The status code does not indicate success for the specified response.
    case noSuccessResponse(code: String)
    
    /// Notify the internet isn't connected.
    case noInternet

    public var description: String {
        switch self {
        case .unableToGenerateURLRequest:
            return NSLocalizedString(
                "Unable to generate the URL request for the given options.",
                comment: "Unable to generate the URL request for the given options.")
        case .badDeserialization(let error):
            return NSLocalizedString(
                "Deserialization failed.",
                comment: error.localizedDescription)
        case .invalidResponse:
            return NSLocalizedString(
                "Fetch error. Found invalid response.",
                comment: "There was an invalid response from the network.")
        case .noSuccessResponse(let code):
            switch code {
            case "404":
                return NSLocalizedString("Cannot get the forecast data, please try again!", comment: "")
            default:
                return NSLocalizedString(
                    "Server did not return success status. Code: \(code)",
                    comment: "The status code does not indicate success for the specified response.")
            }
        case .fetchError(let error):
            return NSLocalizedString(
                "Error occured. Error: \(error)",
                comment: "Unable to fetch with the specified underlying error.")
        case .noInternet:
            return NSLocalizedString("The internet isn't connected, check your connection, then try again", comment: "")
        }
    }
}
