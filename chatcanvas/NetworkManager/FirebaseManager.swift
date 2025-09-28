//
//  FirebaseManager.swift
//  chatcanvas
//
//  Created by Müge Deniz on 22.04.2025.
//

import Foundation
import Alamofire

class NetworkCaller {
    static let shared = NetworkCaller()
    
    private init() {} // Ensure singleton usage
    
    func fetchBackgroundData(completion: @escaping (Swift.Result<BackgroundModel, Error>) -> Void) {
        let url = "https://chatcanvas-f570c-default-rtdb.firebaseio.com/.json"
        AF.request(url)
            .validate()
            .responseDecodable(of: BackgroundModel.self) { response in
                switch response.result {
                case .success(let backgroundModel):
                    completion(.success(backgroundModel))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func fetchBackgroundDataWithCache(completion: @escaping (Swift.Result<BackgroundModel, Error>) -> Void) {
        if let cachedData = CacheManager.shared.getBackgroundData() {
            completion(.success(cachedData))
            return
        }
        
        fetchBackgroundData { (result: Swift.Result<BackgroundModel, Error>) in
            switch result {
            case .success(let data):
                CacheManager.shared.saveBackgroundData(data)
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}



