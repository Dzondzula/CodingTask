//
//  VCViewModel.swift
//  CodingTaskMobile
//
//  Created by Nikola Andrijasevic on 23.5.22..
//

import Foundation

enum GitError: Error,CustomStringConvertible{
    case noDataAvailable
    case connectionError
    case networkError
    var description: String{
        switch self{
            
        case .noDataAvailable:
            return "Cannot process data"
        case .connectionError:
            return "Error while trying to get data"
        case .networkError:
            return "Network status error"
        }
    }
    
}

struct VCViewModel{
    var isSorted = false
    var sortedMost = "Sort by most stars"
    var sortedLeast = "Sort by least stars"
    var networkError = "Network problem"
    
    //var urlRepos = "https://api.github.com/users/octocat/repos"
    
    let resourceUrl: URL
    var session: URLSessionProtocol = URLSession.shared
    
    init(user: String){
        
        let resourceString = "https://api.github.com/users/\(user)/repos"
        guard let resourceURL = URL(string: resourceString) else{fatalError()}
        self.resourceUrl = resourceURL
    }
    
    
    func fetchData(completionHandler: @escaping (Result<[GitInfo],GitError>)->Void){
       
        session.dataTask(with: resourceUrl){ data,response,error in
            var decoded : [GitInfo] = []
            
            if error != nil {
                completionHandler(.failure(.connectionError))
            } else if let response = response as? HTTPURLResponse,response.statusCode != 200{
                completionHandler(.failure(.networkError))
            } else if let data = data {
                do{
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    decoded = try decoder.decode([GitInfo].self, from: data)
                    completionHandler(.success(decoded))
                } catch {
                    
                    completionHandler(.failure(.noDataAvailable))
                }
            }
            
        }.resume()
        
    }
}





