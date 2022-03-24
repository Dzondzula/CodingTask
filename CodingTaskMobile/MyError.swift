//
//  MyError.swift
//  CodingTaskMobile
//
//  Created by Nikola Andrijasevic on 24.3.22..
//

import Foundation

struct MyError: LocalizedError {
    let message: String
    var errorDescription: String? { message }
}
