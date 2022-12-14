//
//  NetworkManager.swift
//  DH_Video_Lite
//
//  Created by Aybike Zeynep Tiryaki on 17.11.2022.
//


import Moya

protocol Networkable {
    var provider: MoyaProvider<API> { get }

    func fetchVideoData(completion: @escaping (Result<DHVideoModel, Error>) -> ())
}

class NetworkManager: Networkable {
    
    var provider = MoyaProvider<API>(plugins: [NetworkLoggerPlugin()])

    func fetchVideoData(completion: @escaping (Result<DHVideoModel, Error>) -> ()) {
        request(target: .newestVideo, completion: completion)
    }
    
    
}

private extension NetworkManager {
    private func request<T: Decodable>(target: API, completion: @escaping (Result<T, Error>) -> ()) {
        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(results))
                } catch let error {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

