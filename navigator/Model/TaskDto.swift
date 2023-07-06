//
//  TaskDto.swift
//  navigator
//
//  Created by Roberto Almeida on 6/13/23.
//

import Foundation

struct TaskDto: Codable, Identifiable {
    let id: String
    let type: String
    var date: String
    let description: String
    let addressId: String?
    let address: String?
    let asigneeId: String?
    let longitude: Double?
    let latitude: Double?
    let data: String?
    var status: String
}
