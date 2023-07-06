//
//  UpdateTask.swift
//  navigator
//
//  Created by Roberto Almeida on 6/17/23.
//

import Foundation

struct UpdateTask: Codable {
    let user: String
    let date: String
    let task: String
    let status: String
    let data: String?
}
