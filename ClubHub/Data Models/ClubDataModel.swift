//
//  ClubDataModel.swift
//  ClubHub
//
//  Created by Hardik on 04/11/25.
//

import Foundation

final class ClubDataModel {
    static let shared = ClubDataModel()
    private init() {}
    
    private(set) var clubs: [Club] = []

    
    func getAllClubs() -> [Club] {
        return clubs
    }
    
    func getClub(by id: String) -> Club? {
        return clubs.first { $0.id == id }
    }
    func addMember(studentID: String, to clubID: String) {
        guard let clubIndex = clubs.firstIndex(where: { $0.id == clubID }),
              let student = StudentDataModel.shared.getStudent(by: studentID) else { return }

        if clubs[clubIndex].members == nil {
            clubs[clubIndex].members = []
        }
        if !(clubs[clubIndex].members?.contains(where: { $0.id == studentID }) ?? false) {
            clubs[clubIndex].members?.append(student)
        }
    }

    func removeMember(studentID: String, from clubID: String) {
        guard let clubIndex = clubs.firstIndex(where: { $0.id == clubID }) else { return }
        clubs[clubIndex].members?.removeAll(where: { $0.id == studentID })
    }

}

    
  

