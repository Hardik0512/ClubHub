//
//  BadgeDataModel.swift
//  ClubHub
//
//  Created by Hardik on 04/11/25.
//

import Foundation

class BadgeDataModel {
    static let shared = BadgeDataModel()
    private init() { loadFromPlist() }

    private(set) var badges: [Badge] = []

    // MARK: - CRUD
    func addBadge(_ badge: Badge) {
        badges.append(badge)
        saveToPlist()
    }

    func getAllBadges() -> [Badge] {
        return badges.sorted { $0.dateEarned > $1.dateEarned }
    }

    func getBadge(by id: String) -> Badge? {
        return badges.first { $0.id == id }
    }

    func removeBadge(by id: String) {
        badges.removeAll { $0.id == id }
        saveToPlist()
    }

    // MARK: - Award Logic (Tier-wise system)
    func awardBadgeIfEligible(for student: Student) {
        let totalEvents = student.pastEventIDs?.count ?? 0
        let totalPoints = totalEvents * 100

        var newBadge: Badge?

        switch totalEvents {
        case 1:
            newBadge = Badge(id: UUID().uuidString,
                             title: "Beginner",
                             description: "You’ve attended your first event!",
                             points: totalPoints,
                             dateEarned: Date(),
                             iconName: "1.circle.fill",
                             tier: 1)

        case 5:
            newBadge = Badge(id: UUID().uuidString,
                             title: "Active Member",
                             description: "5 events strong! Keep it going!",
                             points: totalPoints,
                             dateEarned: Date(),
                             iconName: "star.fill",
                             tier: 2)

        case 10:
            newBadge = Badge(id: UUID().uuidString,
                             title: "Enthusiast",
                             description: "10 events completed — you’re shining bright!",
                             points: totalPoints,
                             dateEarned: Date(),
                             iconName: "flame.fill",
                             tier: 3)

        case 20:
            newBadge = Badge(id: UUID().uuidString,
                             title: "Leader",
                             description: "20 events! You’re a true leader on campus!",
                             points: totalPoints,
                             dateEarned: Date(),
                             iconName: "crown.fill",
                             tier: 4)

        case 30:
            newBadge = Badge(id: UUID().uuidString,
                             title: "Legend",
                             description: "30+ events — you’ve made history!",
                             points: totalPoints,
                             dateEarned: Date(),
                             iconName: "trophy.fill",
                             tier: 5)

        default:
            break
        }

        if let badge = newBadge {
            addBadge(badge)
            StudentDataModel.shared.addBadgeToStudent(studentID: student.id, badgeID: badge.id)
        }
    }

    // MARK: - Point Calculation
    func calculatePoints(for student: Student) -> Int {
        return (student.pastEventIDs?.count ?? 0) * 100
    }

    // MARK: - Progress Bar Calculation
    func getProgress(for student: Student) -> Double {
        let events = student.pastEventIDs?.count ?? 0
        let maxEvents = 30.0  // Legend level
        return min(Double(events) / maxEvents, 1.0) // 0.0 to 1.0
    }

    // MARK: - Persistence (Plist)
    private var plistURL: URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent("Badges.plist")
    }

    func saveToPlist() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(badges)
            try data.write(to: plistURL)
            print("✅ Badges saved to plist")
        } catch {
            print("❌ Error saving badges: \(error)")
        }
    }

    func loadFromPlist() {
        let decoder = PropertyListDecoder()
        do {
            let data = try Data(contentsOf: plistURL)
            badges = try decoder.decode([Badge].self, from: data)
            print("✅ Badges loaded from plist")
        } catch {
            print("⚠️ No saved badges found or failed to load: \(error)")
        }
    }
}
