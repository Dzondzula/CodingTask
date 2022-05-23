//
//  Model.swift
//  CodingTaskMobile
//
//  Created by Nikola Andrijasevic on 16.3.22..
//

import UIKit

struct Commit: Decodable,Equatable {
    var committer: CommitterPic
    var commit: Committer
}

struct Committer: Decodable,Equatable{
    var author: AuthorDetail
    var message: String
}

struct AuthorDetail: Decodable,Equatable{
    var name : String   
}

struct CommitterPic: Decodable,Equatable{
    var avatarUrl: String
}


struct GitInfo : Decodable,Equatable{
    
    var fullName : String
    var owner : OwnerInfo
    var description : String?
    var openIssues : Int
    var forksCount : Int
    var stargazersCount : Int
    
}

struct OwnerInfo : Decodable,Equatable{
    var avatarUrl : String
}
