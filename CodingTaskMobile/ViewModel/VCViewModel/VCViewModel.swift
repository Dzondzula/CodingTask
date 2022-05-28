//
//  VCViewModel.swift
//  CodingTaskMobile
//
//  Created by Nikola Andrijasevic on 23.5.22..
//

import Foundation

enum Errors: LocalizedError,CustomStringConvertible{
    case noDataAvailable
    
    var description: String{
        return "Network error"
    }
    
}

struct VCViewModel{
    var isSorted = false
    var sortedMost = "Sort by most stars"
    var sortedLeast = "Sort by least stars"
    
    var urlRepos = "https://api.github.com/users/octocat/repos"
    
}





