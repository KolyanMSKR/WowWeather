//
//  NetworkService.swift
//  WowWeather
//
//  Created by asd dsa on 10/23/19.
//  Copyright © 2019 asd dsa. All rights reserved.
//

import Foundation
import CoreLocation

class NetworkService {
    
    private func createDataTask(request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            
            guard let httpStatusCode = (response as? HTTPURLResponse)?.statusCode else {
                completion(nil, error)
                
                return
            }
            
            if (200...299).contains(httpStatusCode) == false {
                return completion(nil, error)
            }
            
            DispatchQueue.main.async {
                completion(data, error)
            }
        })
        
        task.resume()
    }
    
    
    func fetchJSONData<DataModel>(request: URLRequest, modelType: DataModel.Type, completion: @escaping (DataModel?) -> ())
        where DataModel: Decodable {
            createDataTask(request: request) { data, error in
                guard let data = data else {
                    return completion(nil)
                }
                
                do {
                    let jsonData = try JSONDecoder().decode(modelType.self, from: data)
                    completion(jsonData)
                } catch {
                    print(error)
                    completion(nil)
                }
            }
    }
    
}
