//
//  StudentDataModel.swift
//  ClubHub
//
//  Created by Hardik on 04/11/25.
//

import Foundation

class StudentDataModel {
    static let shared = StudentDataModel()
    private init() { loadFromPlist() }
    
    private(set) var students: [Student] = []
    private(set) var currentStudent: Student?
    
    // MARK: - CRUD
    
    func setCurrentStudent(_ student: Student) {
        self.currentStudent = student
    }
    
    func addStudent(_ student: Student) {
        students.append(student)
        saveToPlist()
    }
    
    func getAllStudents() -> [Student] {
        return students
    }
    
    func getStudent(by id: String) -> Student? {
        return students.first { $0.id == id }
    }
    func getStudents(byIDs ids: [String]) -> [Student] {
    return students.filter { ids.contains($0.id) }
}
   
    func getStudent(byEmail email: String) -> Student? {
        // fetch User by email first since Student now stores userID only
        guard let user = UserDataModel.shared.getUser(byEmail: email) else { return nil }
        return students.first { $0.userID == user.id }
    }
    
    func updateStudent(_ updatedStudent: Student) {
        if let index = students.firstIndex(where: { $0.id == updatedStudent.id }) {
            students[index] = updatedStudent
            saveToPlist()
        }
    }
    
    func removeStudent(by id: String) {
        students.removeAll { $0.id == id }
        saveToPlist()
    }
    
    // MARK: - Follow / Unfollow Clubs
    
    func followClub(studentID: String, clubID: String) {
        guard let studentIndex = students.firstIndex(where: { $0.id == studentID }) else { return }
        if students[studentIndex].followingClubIDs == nil {
            students[studentIndex].followingClubIDs = []
        }
        
        // Prevent duplicates
        if !(students[studentIndex].followingClubIDs?.contains(clubID) ?? false) {
            students[studentIndex].followingClubIDs?.append(clubID)
            ClubDataModel.shared.addMember(studentID: studentID, to: clubID)
            saveToPlist()
        }
    }
    
    func unfollowClub(studentID: String, clubID: String) {
        guard let studentIndex = students.firstIndex(where: { $0.id == studentID }) else { return }
        students[studentIndex].followingClubIDs?.removeAll(where: { $0 == clubID })
        ClubDataModel.shared.removeMember(studentID: studentID, from: clubID)
        saveToPlist()
    }
    
    func getFollowedClubs(for studentID: String) -> [Club] {
        guard let student = students.first(where: { $0.id == studentID }) else { return [] }
        let followedIDs = student.followingClubIDs ?? []
        return ClubDataModel.shared.getClubs(byIDs: followedIDs)
    }
    
    // MARK: - Event Management
    
    func registerForEvent(_ eventID: String, studentID: String) {
        guard let studentIndex = students.firstIndex(where: { $0.id == studentID }) else { return }
        
        if students[studentIndex].registeredEventIDs == nil {
            students[studentIndex].registeredEventIDs = []
        }
        
        if !(students[studentIndex].registeredEventIDs?.contains(eventID) ?? false) {
            students[studentIndex].registeredEventIDs?.append(eventID)
            EventDataModel.shared.register(studentID: studentID, for: eventID)
            logActivity(type: .registered, title: "Registered for Event: \(eventID)")
            saveToPlist()
        }
    }
    
    
    func getUpcomingEvents(for studentID: String) -> [Event] {
        guard let student = students.first(where: { $0.id == studentID }) else { return [] }
        let registeredIDs = student.registeredEventIDs ?? []
        let allEvents = EventDataModel.shared.getEvents(byIDs: registeredIDs)
        return allEvents.filter { $0.date >= Date() }
    }
    
    // MARK: - Activities
    
    func logActivity(type: ActivityType, title: String) {
        guard let student = currentStudent else { return }
        
        let newLog = ActivityLog(
            id: UUID().uuidString,
            studentId: student.id,
            title: title,
            type: type,
            timestamp: Date()
        )
        
        ActivityLogDataModel.shared.addActivity(newLog)
    }
    
    func getRecentActivities(for studentID: String) -> [ActivityLog] {
        return ActivityLogDataModel.shared.getActivities(for: studentID)
    }
    
    func addBadgeToStudent(studentID: String, badgeID: String) {
            guard let index = students.firstIndex(where: { $0.id == studentID }) else { return }

            // Initialize array if it's nil
            if students[index].badgeIDs == nil {
                students[index].badgeIDs = []
            }

            // Add only if not already present
            if !(students[index].badgeIDs?.contains(badgeID) ?? false) {
                students[index].badgeIDs?.append(badgeID)
                saveToPlist()
                print("🏅 Badge \(badgeID) added to student \(studentID)")
            }
        }
    
    // MARK: - Plist Persistence
    
    private var plistURL: URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return path.appendingPathComponent("Students.plist")
    }
    
    func saveToPlist() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(students)
            try data.write(to: plistURL)
        } catch {
            print("❌ Error saving students: \(error)")
        }
    }
    
    func loadFromPlist() {
        let decoder = PropertyListDecoder()
        do {
            let data = try Data(contentsOf: plistURL)
            students = try decoder.decode([Student].self, from: data)
        } catch {
            print("⚠️ No saved students found or failed to load: \(error)")
        }
    }
}
