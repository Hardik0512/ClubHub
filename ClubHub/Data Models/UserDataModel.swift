//
//  UserDataModel.swift
//  ClubHub
//
//  Created by Hardik on 04/11/25.
//

import Foundation

final class UserDataModel {
    static let shared = UserDataModel()
    private init() {}
    
    private(set) var users: [User] = []
    
    func addUser(_ user: User) {
        users.append(user)
    }
    
    func getAllUsers() -> [User] {
        return users
    }
    
    func getUser(by id: String) -> User? {
        return users.first { $0.id == id }
    }
    
    func getUser(byEmail email: String) -> User? {
        return users.first { $0.email == email }
    }
    
    func updateUser(_ updatedUser: User) {
        if let index = users.firstIndex(where: { $0.id == updatedUser.id }) {
            users[index] = updatedUser
        }
    }
    
    func removeUser(by id: String) {
        users.removeAll { $0.id == id }
    }
}
