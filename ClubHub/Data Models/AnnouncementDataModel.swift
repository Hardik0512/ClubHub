//
//  AnnouncementDataModel.swift
//  ClubHub
//
//  Created by Hardik on 10/11/25.
//

import Foundation

import Foundation

class AnnouncementDataModel {
    static let shared = AnnouncementDataModel()
    private init() { loadFromPlist() }
    
    private(set) var announcements: [Announcement] = []
    
    // MARK: - CRUD
    
    func addAnnouncement(_ announcement: Announcement) {
        announcements.append(announcement)
        saveToPlist()
    }
    
    func getAllAnnouncements() -> [Announcement] {
        return announcements.sorted { $0.createdAt > $1.createdAt } // newest first
    }
    
    func getAnnouncement(by id: String) -> Announcement? {
        return announcements.first { $0.id == id }
    }
    
    func updateAnnouncement(_ updated: Announcement) {
        if let index = announcements.firstIndex(where: { $0.id == updated.id }) {
            announcements[index] = updated
            saveToPlist()
        }
    }
    
    func removeAnnouncement(by id: String) {
        announcements.removeAll { $0.id == id }
        saveToPlist()
    }
    
    // MARK: - Filters
    
    func getAnnouncements(for clubID: String) -> [Announcement] {
        return announcements
            .filter { $0.clubID == clubID }
            .sorted { $0.createdAt > $1.createdAt }
    }
    
    func getAnnouncements(of type: AnnouncementType) -> [Announcement] {
        return announcements
            .filter { $0.type == type }
            .sorted { $0.createdAt > $1.createdAt }
    }
    
    func searchAnnouncements(containing query: String) -> [Announcement] {
        guard !query.isEmpty else { return getAllAnnouncements() }
        return announcements.filter {
            $0.title.lowercased().contains(query.lowercased()) ||
            $0.message.lowercased().contains(query.lowercased())
        }
    }
    
    // MARK: - Plist Persistence
    
    private var plistURL: URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return path.appendingPathComponent("Announcements.plist")
    }
    
    func saveToPlist() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(announcements)
            try data.write(to: plistURL)
            print("✅ Announcements saved to plist")
        } catch {
            print("❌ Error saving announcements: \(error)")
        }
    }
    
    func loadFromPlist() {
        let decoder = PropertyListDecoder()
        do {
            let data = try Data(contentsOf: plistURL)
            announcements = try decoder.decode([Announcement].self, from: data)
            print("✅ Announcements loaded from plist")
        } catch {
            print("⚠️ No saved announcements found or failed to load: \(error)")
        }
    }
}

