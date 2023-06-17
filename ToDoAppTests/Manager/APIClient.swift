//
//  APIClient.swift
//  ToDoAppTests
//
//  Created by Сергей Насыбуллин on 16.06.2023.
//

import Foundation


enum NetworkError: Error {
    case emptData
    case emptServer
}


protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

class APIClient {
    
    lazy var urlSession: URLSessionProtocol = URLSession.shared
    
    
    func login(withName name: String, password: String, completionHadler: @escaping(String?, Error?) -> Void) {
        
        let allowedCharecters = CharacterSet.urlQueryAllowed
        
        guard
            let name = name.addingPercentEncoding(withAllowedCharacters: allowedCharecters),
            let password = password.addingPercentEncoding(withAllowedCharacters: allowedCharecters) else {
            fatalError()
        }
        
        let query = "name=\(name)&password=\(password)"
        guard let url = URL(string: "https://todoapp.com/login?\(query)") else {
            fatalError()
        }
        
        urlSession.dataTask(with: url) { (data, response, error) in
            do {
                if error != nil {
                    throw NetworkError.emptServer
                }
                guard let data = data else {
                    completionHadler(nil, NetworkError.emptData)
                    return
                }
                let dictionary = try JSONSerialization.jsonObject(with: data) as! [String : String]
                let token = dictionary["token"]
                completionHadler(token, nil)
            } catch {
                completionHadler(nil, error)
            }
        }.resume()
    }
    
    
}
