//
//  ClubHeadDataModel.swift
//  ClubHub
//
//  Created by Hardik on 04/11/25.
//

import Foundation

final class ClubHeadDataModel {
    static let shared = ClubHeadDataModel()
    private init() {}
    
    private(set) var clubHeads: [ClubHead] = []
    
    func addClubHead(_ clubHead: ClubHead) {
        clubHeads.append(clubHead)
    }
    
    func getAllClubHeads() -> [ClubHead] {
        return clubHeads
    }
    
    func getClubHead(by id: String) -> ClubHead? {
        return clubHeads.first { $0.id == id }
    }
    
    func updateClubHead(_ updatedClubHead: ClubHead) {
        if let index = clubHeads.firstIndex(where: { $0.id == updatedClubHead.id }) {
            clubHeads[index] = updatedClubHead
        }
    }
    
    func removeClubHead(by id: String) {
        clubHeads.removeAll { $0.id == id }
    }
}
