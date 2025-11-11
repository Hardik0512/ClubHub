//
//  ActivityLogDataModel.swift
//  ClubHub
//
//  Created by Hardik on 10/11/25.
//

import Foundation

class ActivityLogDataModel {
    static let shared = ActivityLogDataModel()
    private init() { loadFromPlist() }
    
    private(set) var activityLogs: [ActivityLog] = []
    
    // MARK: - CRUD
    
    func addActivity(_ activity: ActivityLog) {
        activityLogs.insert(activity, at: 0) // Insert newest on top
        saveToPlist()
    }
    
    func getAllActivities() -> [ActivityLog] {
        return activityLogs.sorted { $0.timestamp > $1.timestamp }
    }
    
    func getActivity(by id: String) -> ActivityLog? {
        return activityLogs.first { $0.id == id }
    }
    
    func removeActivity(by id: String) {
        activityLogs.removeAll { $0.id == id }
        saveToPlist()
    }
    
    func clearAllActivities() {
        activityLogs.removeAll()
        saveToPlist()
    }
    
    // MARK: - Filter
    
    func getActivities(for studentID: String) -> [ActivityLog] {
        return activityLogs
            .filter { $0.studentId == studentID }
            .sorted { $0.timestamp > $1.timestamp }
    }
    
    func getActivities(of type: ActivityType, for studentID: String) -> [ActivityLog] {
        return activityLogs
            .filter { $0.studentId == studentID && $0.type == type }
            .sorted { $0.timestamp > $1.timestamp }
    }
    
    // MARK: - Persistence
    
    private var plistURL: URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent("ActivityLogs.plist")
    }
    
    func saveToPlist() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(activityLogs)
            try data.write(to: plistURL)
            print("✅ Activity logs saved to plist")
        } catch {
            print("❌ Error saving activity logs: \(error)")
        }
    }
    
    func loadFromPlist() {
        let decoder = PropertyListDecoder()
        do {
            let data = try Data(contentsOf: plistURL)
            activityLogs = try decoder.decode([ActivityLog].self, from: data)
            print("✅ Activity logs loaded from plist")
        } catch {
            print("⚠️ No saved logs found or failed to load: \(error)")
        }
    }
}


