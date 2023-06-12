//
//  User.swift
//  navigator
//
//  Created by Roberto Almeida on 3/11/22.
//

import Foundation


struct User {
    public var id: String
    public var username: String
    
    public init(id: String = UUID().uuidString,
        username: String) {
        self.id = id
        self.username = username
    }
}
