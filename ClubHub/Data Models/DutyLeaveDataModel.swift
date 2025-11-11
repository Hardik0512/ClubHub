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
    
    func addDutyLeave(_ dutyLeave: DutyLeave) {
        dutyLeaves.append(dutyLeave)
        saveToPlist()
    }
    
    func getAllDutyLeaves() -> [DutyLeave] {
        // Sorted: newest first
        return dutyLeaves.sorted { $0.createdAt > $1.createdAt }
    }
    
    func getDutyLeave(by id: String) -> DutyLeave? {
        return dutyLeaves.first { $0.id == id }
    }
    
    func removeDutyLeave(by id: String) {
        dutyLeaves.removeAll { $0.id == id }
        saveToPlist()
    }
    
    // MARK: - Filter Functions
    
    func getDutyLeaves(forStudentID studentID: String) -> [DutyLeave] {
        return dutyLeaves
            .filter { $0.studentID == studentID }
            .sorted { $0.createdAt > $1.createdAt }
    }
    
    func getDutyLeaves(forEventID eventID: String) -> [DutyLeave] {
        return dutyLeaves
            .filter { $0.eventID == eventID }
            .sorted { $0.createdAt > $1.createdAt }
    }
    
    func getPendingDutyLeaves() -> [DutyLeave] {
        return dutyLeaves.filter { $0.status == .pending }
    }
    
    func getApprovedDutyLeaves() -> [DutyLeave] {
        return dutyLeaves.filter { $0.status == .approved }
    }
    
    func getRejectedDutyLeaves() -> [DutyLeave] {
        return dutyLeaves.filter { $0.status == .rejected }
    }
    
    // MARK: - Status Update
    
    func approveDutyLeave(by id: String) {
        if let index = dutyLeaves.firstIndex(where: { $0.id == id }) {
            dutyLeaves[index].status = .approved
            saveToPlist()
            
            // Log student activity
            let studentID = dutyLeaves[index].studentID
            StudentDataModel.shared.logActivity(type: .approvedDL, title: "Duty Leave Approved")
        }
    }
    
    func rejectDutyLeave(by id: String) {
        if let index = dutyLeaves.firstIndex(where: { $0.id == id }) {
            dutyLeaves[index].status = .rejected
            saveToPlist()
            
            // Log student activity
            let studentID = dutyLeaves[index].studentID
            StudentDataModel.shared.logActivity(type: .rejectedDL, title: "Duty Leave Rejected")
        }
    }
    
    // MARK: - Create Duty Leave from Scan
    
    func createDutyLeaveFromScan(studentID: String, eventID: String, qrValue: String) {
        let newDutyLeave = DutyLeave(
            id: UUID().uuidString,
            studentID: studentID,
            eventID: eventID,
            qrCodeValue: qrValue,
            status: .pending,
            createdAt: Date()
        )
        
        addDutyLeave(newDutyLeave)
        
        // Log this activity
        StudentDataModel.shared.logActivity(type: .submittedDL, title: "Submitted Duty Leave for Event ID: \(eventID)")
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

//final class DutyLeaveDataModel {
//    static let shared = DutyLeaveDataModel()
//    private init() {}
//    
//    private(set) var dutyLeaves: [DutyLeave] = []
//    
//    // MARK: - CRUD Operations
//    
//    func addDutyLeave(_ dutyLeave: DutyLeave) {
//        dutyLeaves.append(dutyLeave)
//    }
//    
//    func getAllDutyLeaves() -> [DutyLeave] {
//        return dutyLeaves
//    }
//    
//    func getDutyLeave(by id: String) -> DutyLeave? {
//        return dutyLeaves.first { $0.id == id }
//    }
//    
//    func removeDutyLeave(by id: String) {
//        dutyLeaves.removeAll { $0.id == id }
//    }
//    
//    // MARK: - Filter Functions
//    
//    func getDutyLeaves(forStudentID studentID: String) -> [DutyLeave] {
//        return dutyLeaves.filter { $0.studentID == studentID }
//    }
//    
//    func getDutyLeaves(forEventID eventID: String) -> [DutyLeave] {
//        return dutyLeaves.filter { $0.eventID == eventID }
//    }
//    
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
//    
//    // MARK: - Status Update Functions
//    
//    func approveDutyLeave(by id: String) {
//        if let index = dutyLeaves.firstIndex(where: { $0.id == id }) {
//            dutyLeaves[index].status = .approved
//        }
//    }
//    
//    func rejectDutyLeave(by id: String) {
//        if let index = dutyLeaves.firstIndex(where: { $0.id == id }) {
//            dutyLeaves[index].status = .rejected
//        }
//    }
//    
//    // MARK: - Create Duty Leave from Scan
//    
//    func createDutyLeaveFromScan(studentID: String, eventID: String, qrValue: String) {
//        let newDutyLeave = DutyLeave(
//            id: UUID().uuidString,
//            eventID: eventID,
//            studentID: studentID,
//            qrCodeValue: qrValue,
//            status: .pending,
//            createdAt: Date()
//        )
//        addDutyLeave(newDutyLeave)
//    }
//}
//
