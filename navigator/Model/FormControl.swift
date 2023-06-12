//
//  FormControl.swift
//  navigator
//
//  Created by Roberto Almeida on 4/07/22.
//
import Foundation
import SwiftUI

struct FormControl: Codable, Identifiable {
    let id: String
    let controlType: String
    let label: String
    let required: Bool
    var value: String = ""
    var dateValue: Date {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.date(from: value) ?? Date()
        }
        
        set {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            value = formatter.string(from: newValue)
        }
    }
    var image: UIImage?
    
    
    private enum CodingKeys: String, CodingKey {
        case id, controlType, label, required
    }

}
