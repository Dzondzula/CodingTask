//
//  VCTableViewModel.swift
//  CodingTaskMobile
//
//  Created by Nikola Andrijasevic on 28.5.22..
//

import Foundation

struct RepositoryTabelViewModel{
    let repository: [GitInfo]
    
    func fullName(for index: Int) -> String{
        let repo = repository[index]
        let name = repo.fullName
        return "\(name)"
    }
    
    func starCount(for index: Int) -> String{
        let repo = repository[index]
        let star = repo.stargazersCount
        return "\(star)"
    }
    
    func description(for index: Int) -> String?{
        let repo = repository[index]
        guard let description = repo.description else{return nil}
        return "\(description)"
    }
    
    func owner(for index: Int) -> String{
        let repo = repository[index]
        let url = repo.owner.avatarUrl
        return "\(url)"
    }
    
    func issues(for index: Int) -> String{
        let repo = repository[index]
        let issues = repo.fullName
        return "\(issues)"
    }
    
    func forksCount(for index: Int) -> String{
        let repo = repository[index]
        let forks = repo.fullName
        return "\(forks)"
    }
    
    func viewModel(for index: Int)-> RepositoryCellViewModel{
        return RepositoryCellViewModel(repository: repository[index])
    }
    
    func viewModelDetail(for index: Int)-> GitInfo{
        return repository[index]
    }
}



struct RepositoryCellViewModel{
    let repository: GitInfo
    
    var fullName: String{
        let name = repository.fullName
        return name
    }
    var starNumber: String{
        let star = repository.stargazersCount
        return "\(star)"
    }
    var description: String?{
        let description = repository.description
        return description
    }
    var owner: String{
        let url = repository.owner.avatarUrl
        return url
    }
    var issues: String{
        let issues = repository.openIssues
        return "\(issues)"
    }
    var forks: String{
        let forks = repository.forksCount
        return "\(forks)"
    }
    
    
}

protocol RepoRepresentable{
    var fullName: String { get }
    var starNumber: String { get }
    var description: String? { get }
    var owner: String { get }
    var issues: String { get }
    var forks: String { get }
    
}

extension RepositoryCellViewModel: RepoRepresentable{}
