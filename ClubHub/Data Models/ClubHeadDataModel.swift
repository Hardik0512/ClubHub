//
//  ClubHeadDataModel.swift
//  ClubHub
//
//  Created by Hardik on 04/11/25.
//

import Foundation

class ClubHeadDataModel {
    static let shared = ClubHeadDataModel()
    private init() { loadFromPlist() }
    
    private(set) var clubHeads: [ClubHead] = []
    
    func addClubHead(_ clubHead: ClubHead) {
        clubHeads.append(clubHead)
        saveToPlist()
    }
    
    func getAllClubHeads() -> [ClubHead] {
        return clubHeads
    }
    
    func getClubHead(by id: String) -> ClubHead? {
        return clubHeads.first { $0.id == id }
    }
    func getClubHeads(byIDs ids: [String]) -> [ClubHead] {
    return clubHeads.filter { ids.contains($0.id) }
}

    func removeClubHead(by id: String) {
        clubHeads.removeAll { $0.id == id }
        saveToPlist()
    }
    
    // MARK: - Save & Load to/from Plist
    private var plistURL: URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return path.appendingPathComponent("ClubHeads.plist")
    }
    
    func saveToPlist() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(clubHeads)
            try data.write(to: plistURL)
            print("✅ ClubHeads saved to plist")
        } catch {
            print("❌ Error saving club heads: \(error)")
        }
    }
    
    func loadFromPlist() {
        let decoder = PropertyListDecoder()
        do {
            let data = try Data(contentsOf: plistURL)
            clubHeads = try decoder.decode([ClubHead].self, from: data)
            print("✅ ClubHeads loaded from plist")
        } catch {
            print("⚠️ No saved club heads found or failed to load: \(error)")
        }
    }
}



//final class ClubHeadDataModel {
//    static let shared = ClubHeadDataModel()
//    private init() {}
//    
//    private(set) var clubHeads: [ClubHead] = []
//    
//    func addClubHead(_ clubHead: ClubHead) {
//        clubHeads.append(clubHead)
//    }
//    
//    func getAllClubHeads() -> [ClubHead] {
//        return clubHeads
//    }
//    
//    func getClubHead(by id: String) -> ClubHead? {
//        return clubHeads.first { $0.id == id }
//    }
//    
//    func updateClubHead(_ updatedClubHead: ClubHead) {
//        if let index = clubHeads.firstIndex(where: { $0.id == updatedClubHead.id }) {
//            clubHeads[index] = updatedClubHead
//        }
//    }
//    
//    func removeClubHead(by id: String) {
//        clubHeads.removeAll { $0.id == id }
//    }
//}
