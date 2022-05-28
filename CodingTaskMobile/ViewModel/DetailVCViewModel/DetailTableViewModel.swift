//
//  DetailTableViewModel.swift
//  CodingTaskMobile
//
//  Created by Nikola Andrijasevic on 28.5.22..
//

import Foundation

struct DetailTableViewModel{
    let committer: [Commit]
    
    func commitName(for index: Int) -> String{
        let name = committer[index].commit.author.name
        return "\(name)"
    }
    func commitMessage(for index: Int) -> String{
        let message = committer[index].commit.message
        return "\(message)"
    }
    func commiterPicUrl(for index: Int) -> String{
        let url = committer[index].committer.avatarUrl
        return "\(url)"
    }
    func viewModel(for index: Int)-> DetailTableViewCellViewModel{
        return DetailTableViewCellViewModel(committer: committer[index])
    }
}

struct DetailTableViewCellViewModel{
    let committer: Commit

    var name : String{
        return committer.commit.author.name
    }
    var commitMessage: String{
        return committer.commit.message
    }
    var commiterPicUrl: String{
        return committer.committer.avatarUrl
    }
}
protocol DetailTableCellRepresentable{
    var name : String {get}
    var commitMessage : String {get}
    var commiterPicUrl : String {get}
    
}
extension DetailTableViewCellViewModel:DetailTableCellRepresentable{}
