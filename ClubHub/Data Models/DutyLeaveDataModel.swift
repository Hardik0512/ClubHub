//
//  DutyLeaveDataModel.swift
//  ClubHub
//
//  Created by Hardik on 04/11/25.
//

import Foundation

class DutyLeaveDataModel {
    static let shared = DutyLeaveDataModel()
    private init() { loadFromPlist() }
    
    private(set) var dutyLeaves: [DutyLeave] = []
    
    // MARK: - CRUD Operations
    
//    func addDutyLeave(_ dutyLeave: DutyLeave) {
//        dutyLeaves.append(dutyLeave)
//        saveToPlist()
//    }
    
//    func getAllDutyLeaves() -> [DutyLeave] {
//        // Sorted: newest first
//        return dutyLeaves.sorted { $0.createdAt > $1.createdAt }
//    }
    
//    func getDutyLeave(by id: String) -> DutyLeave? {
//        return dutyLeaves.first { $0.id == id }
//    }
    
//    func removeDutyLeave(by id: String) {
//        dutyLeaves.removeAll { $0.id == id }
//        saveToPlist()
//    }
    
    // MARK: - Filter Functions
    
//    func getDutyLeaves(forStudentID studentID: String) -> [DutyLeave] {
//        return dutyLeaves
//            .filter { $0.studentID == studentID }
//            .sorted { $0.createdAt > $1.createdAt }
//    }
    
    func getDutyLeaves(forEventID eventID: String) -> [DutyLeave] {
        return dutyLeaves
            .filter { $0.eventID == eventID }
            .sorted { $0.createdAt > $1.createdAt }
    }

//    func getPendingDutyLeaves() -> [DutyLeave] {
//        return dutyLeaves.filter { $0.status == .pending }
//    }
//    
//    func getApprovedDutyLeaves() -> [DutyLeave] {
//        return dutyLeaves.filter { $0.status == .approved }
//    }
//    
//    func getRejectedDutyLeaves() -> [DutyLeave] {
//        return dutyLeaves.filter { $0.status == .rejected }
//    }
    
    // MARK: - Status Update
    
    
    func approveDutyLeave(by id: String) {
        if let index = dutyLeaves.firstIndex(where: { $0.id == id }) {
            
            dutyLeaves[index].status = .approved
            saveToPlist()
            
            let studentID = dutyLeaves[index].studentID
            let eventID = dutyLeaves[index].eventID
            
            // Fetch event name
            let eventName = EventDataModel.shared.getEvent(by: eventID)?.name ?? "Event"
            
            // Log activity for that specific student
            StudentDataModel.shared.logActivity(
                studentID: studentID,
                type: .approvedDL,
                title: "Duty Leave Approved for \(eventName)"
            )
        }
    }

    
    func rejectDutyLeave(by id: String) {
        if let index = dutyLeaves.firstIndex(where: { $0.id == id }) {
            
            dutyLeaves[index].status = .rejected
            saveToPlist()
            
            let studentID = dutyLeaves[index].studentID
            let eventID = dutyLeaves[index].eventID
            
            // Fetch event name
            let eventName = EventDataModel.shared.getEvent(by: eventID)?.name ?? "Event"
            
            // Log activity for that specific student
            StudentDataModel.shared.logActivity(
                studentID: studentID,
                type: .rejectedDL,
                title: "Duty Leave Rejected for \(eventName)"
            )
        }
    }

    
    // Student Section
    func getDutyLeaves(for studentID: String, with status: DutyLeaveStatus? = nil) -> [DutyLeave] {
            let studentDLs = dutyLeaves.filter { $0.studentID == studentID }
            
            if let status = status {
                return studentDLs.filter { $0.status == status }
            }
            return studentDLs
        }

    
    // MARK: - Create Duty Leave from Scan
    
    func createDutyLeaveFromCheckIn(studentID: String, eventID: String) {
            let qrValue = "\(studentID)-\(eventID)-\(UUID().uuidString)"
            let newDL = DutyLeave(
                id: UUID().uuidString,
                studentID: studentID,
                eventID: eventID,
                qrCodeValue: qrValue,
                status: .pending,
                createdAt: Date()
            )
            
            dutyLeaves.append(newDL)
            saveToPlist()
            print("📄 Duty Leave created for \(studentID) in event \(eventID)")
        }
    
    func getDutyLeaves(forClubID clubID: String) -> [DutyLeave] {
        // 1) Get all event IDs belonging to this club
        let clubEventIDs = Set(EventDataModel.shared.events
            .filter { $0.clubID == clubID }
            .map { $0.id })
        
        // 2) Filter duty leaves whose eventID is in that set
        let result = dutyLeaves.filter { clubEventIDs.contains($0.eventID) }
        
        // 3) Sort newest first
        return result.sorted { $0.createdAt > $1.createdAt }
    }
    
    func getApprovedDutyLeaves(forClubID clubID: String) -> [DutyLeave] {
        let clubEventIDs = Set(EventDataModel.shared.events
            .filter { $0.clubID == clubID }
            .map { $0.id })
        return dutyLeaves
            .filter { clubEventIDs.contains($0.eventID) && $0.status == .approved }
            .sorted { $0.createdAt > $1.createdAt }
    }
    
    func getRejectedDutyLeaves(forClubID clubID: String) -> [DutyLeave] {
        let clubEventIDs = Set(EventDataModel.shared.events
            .filter { $0.clubID == clubID }
            .map { $0.id })
        return dutyLeaves
            .filter { clubEventIDs.contains($0.eventID) && $0.status == .rejected }
            .sorted { $0.createdAt > $1.createdAt }
    }

    func getPendingDutyLeaves(forClubID clubID: String) -> [DutyLeave] {
        let clubEventIDs = Set(EventDataModel.shared.events
            .filter { $0.clubID == clubID }
            .map { $0.id })
        return dutyLeaves
            .filter { clubEventIDs.contains($0.eventID) && $0.status != .approved }
            .sorted { $0.createdAt > $1.createdAt }
    }

    
    // MARK: - Persistence (Plist)
    
    private var plistURL: URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent("DutyLeaves.plist")
    }
    
    func saveToPlist() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(dutyLeaves)
            try data.write(to: plistURL)
            print("✅ Duty Leaves saved to plist")
        } catch {
            print("❌ Error saving Duty Leaves: \(error)")
        }
    }
    
    func loadFromPlist() {
        let decoder = PropertyListDecoder()
        do {
            let data = try Data(contentsOf: plistURL)
            dutyLeaves = try decoder.decode([DutyLeave].self, from: data)
            print("✅ Duty Leaves loaded from plist")
        } catch {
            print("⚠️ No saved Duty Leaves found or failed to load: \(error)")
        }
    }
}
