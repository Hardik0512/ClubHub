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

}
