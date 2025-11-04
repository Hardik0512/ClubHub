//
//  DutyLeaveDataModel.swift
//  ClubHub
//
//  Created by Hardik on 04/11/25.
//

import Foundation

final class DutyLeaveDataModel {
    static let shared = DutyLeaveDataModel()
    private init() {}
    
    private(set) var dutyLeaves: [DutyLeave] = []
    
    // MARK: - CRUD Operations
    
    func addDutyLeave(_ dutyLeave: DutyLeave) {
        dutyLeaves.append(dutyLeave)
    }
    
    func getAllDutyLeaves() -> [DutyLeave] {
        return dutyLeaves
    }
    
    func getDutyLeave(by id: String) -> DutyLeave? {
        return dutyLeaves.first { $0.id == id }
    }
    
    func removeDutyLeave(by id: String) {
        dutyLeaves.removeAll { $0.id == id }
    }
    
    // MARK: - Filter Functions
    
    func getDutyLeaves(forStudentID studentID: String) -> [DutyLeave] {
        return dutyLeaves.filter { $0.studentID == studentID }
    }
    
    func getDutyLeaves(forEventID eventID: String) -> [DutyLeave] {
        return dutyLeaves.filter { $0.eventID == eventID }
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
    
    // MARK: - Status Update Functions
    
    func approveDutyLeave(by id: String) {
        if let index = dutyLeaves.firstIndex(where: { $0.id == id }) {
            dutyLeaves[index].status = .approved
        }
    }
    
    func rejectDutyLeave(by id: String) {
        if let index = dutyLeaves.firstIndex(where: { $0.id == id }) {
            dutyLeaves[index].status = .rejected
        }
    }
    
    // MARK: - Create Duty Leave from Scan
    
    func createDutyLeaveFromScan(studentID: String, eventID: String, qrValue: String) {
        let newDutyLeave = DutyLeave(
            id: UUID().uuidString,
            eventID: eventID,
            studentID: studentID,
            qrCodeValue: qrValue,
            status: .pending,
            createdAt: Date()
        )
        addDutyLeave(newDutyLeave)
    }
}
