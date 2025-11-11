//
//  ClubDataModel.swift
//  ClubHub
//
//  Created by Hardik on 04/11/25.
//

import Foundation

class ClubDataModel {
    static let shared = ClubDataModel()
    private init() { loadFromPlist() }
    
    private(set) var clubs: [Club] = []
    
    // MARK: - CRUD
    
    func addClub(_ club: Club) {
        clubs.append(club)
        saveToPlist()
    }
    
    func getAllClubs() -> [Club] {
        return clubs
    }
    
    func getClub(by id: String) -> Club? {
        return clubs.first { $0.id == id }
    }
    
    func updateClub(_ updatedClub: Club) {
        if let index = clubs.firstIndex(where: { $0.id == updatedClub.id }) {
            clubs[index] = updatedClub
            saveToPlist()
        }
    }
    
    func removeClub(by id: String) {
        clubs.removeAll { $0.id == id }
        saveToPlist()
    }
    
    // MARK: - Club Member Management
    
    func addMember(studentID: String, to clubID: String) {
        guard let clubIndex = clubs.firstIndex(where: { $0.id == clubID }) else { return }
        
        if clubs[clubIndex].memberIDs == nil {
            clubs[clubIndex].memberIDs = []
        }
        
        // Avoid duplicates
        if !(clubs[clubIndex].memberIDs?.contains(studentID) ?? false) {
            clubs[clubIndex].memberIDs?.append(studentID)
            saveToPlist()
        }
    }
    
    func removeMember(studentID: String, from clubID: String) {
        guard let clubIndex = clubs.firstIndex(where: { $0.id == clubID }) else { return }
        clubs[clubIndex].memberIDs?.removeAll(where: { $0 == studentID })
        saveToPlist()
    }
    
    func getMembers(for clubID: String) -> [Student] {
        guard let club = getClub(by: clubID),
              let memberIDs = club.memberIDs else { return [] }
        return StudentDataModel.shared.getStudents(byIDs: memberIDs)
    }
    
    // MARK: - Club Head Management
    
    func addClubHead(clubHeadID: String, to clubID: String) {
        guard let index = clubs.firstIndex(where: { $0.id == clubID }) else { return }
        
        if clubs[index].clubHeadIDs == nil {
            clubs[index].clubHeadIDs = []
        }
        
        if !(clubs[index].clubHeadIDs?.contains(clubHeadID) ?? false) {
            clubs[index].clubHeadIDs?.append(clubHeadID)
            saveToPlist()
        }
    }
    
    func getClubHeads(for clubID: String) -> [ClubHead] {
        guard let club = getClub(by: clubID),
              let ids = club.clubHeadIDs else { return [] }
        return ClubHeadDataModel.shared.getClubHeads(byIDs: ids)
    }
    
    // MARK: - Event Management
    
    func addEvent(eventID: String, to clubID: String) {
        guard let clubIndex = clubs.firstIndex(where: { $0.id == clubID }) else { return }
        
        if clubs[clubIndex].eventIDs == nil {
            clubs[clubIndex].eventIDs = []
        }
        
        if !(clubs[clubIndex].eventIDs?.contains(eventID) ?? false) {
            clubs[clubIndex].eventIDs?.append(eventID)
            saveToPlist()
        }
    }
    
    func getEvents(for clubID: String) -> [Event] {
        guard let club = getClub(by: clubID),
              let eventIDs = club.eventIDs else { return [] }
        return EventDataModel.shared.getEvents(byIDs: eventIDs)
    }
    
    // MARK: - Club Search
    
    func searchClubs(containing query: String) -> [Club] {
        guard !query.isEmpty else { return clubs }
        return clubs.filter { $0.name.lowercased().contains(query.lowercased()) }
    }
    
    func getClubs(byIDs ids: [String]) -> [Club] {
        return clubs.filter { ids.contains($0.id) }
    }
    
    // MARK: - Persistence (Plist)
    
    private var plistURL: URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return path.appendingPathComponent("Clubs.plist")
    }
    
    func saveToPlist() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(clubs)
            try data.write(to: plistURL)
            print("✅ Clubs saved to plist")
        } catch {
            print("❌ Error saving clubs: \(error)")
        }
    }
    
    func loadFromPlist() {
        let decoder = PropertyListDecoder()
        do {
            let data = try Data(contentsOf: plistURL)
            clubs = try decoder.decode([Club].self, from: data)
            print("✅ Clubs loaded from plist")
        } catch {
            print("⚠️ No saved clubs found or failed to load: \(error)")
        }
    }
}
