//
//  UserDataModel.swift
//  ClubHub
//
//  Created by Hardik on 04/11/25.
//

import Foundation

class UserDataModel {
    static let shared = UserDataModel()
    private init() { loadFromPlist() }
    
    private(set) var users: [User] = []
    
    func addUser(_ user: User) {
        users.append(user)
        saveToPlist()
    }
    
    func getAllUsers() -> [User] {
        return users
    }
    
    func getUser(byEmail email: String) -> User? {
        return users.first { $0.email.lowercased() == email.lowercased() }
    }
    
    func removeUser(by id: String) {
        users.removeAll { $0.id == id }
        saveToPlist()
    }
    
    // MARK: - Save & Load to/from Plist
    private var plistURL: URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return path.appendingPathComponent("Users.plist")
    }
    
    func saveToPlist() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(users)
            try data.write(to: plistURL)
            print("✅ Users saved to plist")
        } catch {
            print("❌ Error saving users: \(error)")
        }
    }
    
    func loadFromPlist() {
        let decoder = PropertyListDecoder()
        do {
            let data = try Data(contentsOf: plistURL)
            users = try decoder.decode([User].self, from: data)
            print("✅ Users loaded from plist")
        } catch {
            print("⚠️ No saved users found or failed to load: \(error)")
        }
    }
}



//final class UserDataModel {
//    static let shared = UserDataModel()
//    private init() {}
//    
//    private(set) var users: [User] = []
//    
//    func addUser(_ user: User) {
//        users.append(user)
//    }
//    
//    func getAllUsers() -> [User] {
//        return users
//    }
//    
//    func getUser(by id: String) -> User? {
//        return users.first { $0.id == id }
//    }
//    
//    func getUser(byEmail email: String) -> User? {
//        return users.first { $0.email == email }
//    }
//    
//    func updateUser(_ updatedUser: User) {
//        if let index = users.firstIndex(where: { $0.id == updatedUser.id }) {
//            users[index] = updatedUser
//        }
//    }
//    
//    func removeUser(by id: String) {
//        users.removeAll { $0.id == id }
//    }
//}
