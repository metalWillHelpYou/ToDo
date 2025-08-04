//
//  Note.swift
//  ToDo
//
//  Created by metalWillHelpYou on 04.08.2025.
//

import Foundation

struct TodoResponse: Decodable {
    let todos: [Todo]
}

struct Todo: Decodable, Identifiable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}

