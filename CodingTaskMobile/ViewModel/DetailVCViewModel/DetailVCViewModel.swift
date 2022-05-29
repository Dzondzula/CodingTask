//
//  DetailVCViewModel.swift
//  CodingTaskMobile
//
//  Created by Nikola Andrijasevic on 29.5.22..
//
import UIKit
import Foundation

struct DetailVCViewModel{
    
    let resourceUrl: URL
    var session: URLSessionProtocol = URLSession.shared
    
    init(name: String){
        
        let resourceString = "https://api.github.com/repos/\(name)/commits"
        guard let resourceURL = URL(string: resourceString) else{fatalError()}
        self.resourceUrl = resourceURL
    }
    func getCommits(completion: @escaping (Result<[Commit],MyError>)-> Void){
        
        session.dataTask(with: resourceUrl){ data, _, error in
            if let error = error {
                completion(.failure(MyError(message: error.localizedDescription)))
            }
            guard let data = data else {
                completion(.failure(MyError(message: "No data available")))
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let gitCommit = try decoder.decode([Commit].self, from: data)
                let commitDetails = gitCommit
                print(commitDetails)
                completion(.success(commitDetails))
            } catch{
                completion(.failure(MyError(message: "Error while trying to fetch data")))
            }
            
        }.resume()
    }
}
