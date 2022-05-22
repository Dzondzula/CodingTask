//
//  Model.swift
//  CodingTaskMobile
//
//  Created by Nikola Andrijasevic on 16.3.22..
//

import UIKit

//struct Informations: Decodable{
//    var items: [GitInfo]
//}

struct GitInfo : Decodable,Equatable{
    
    var fullName : String
    var owner : OwnerInfo
    var description : String?
    var openIssues : Int
    var stargazersCount : Int
    
    
}

struct OwnerInfo : Decodable,Equatable{
    var avatarUrl : String
}
