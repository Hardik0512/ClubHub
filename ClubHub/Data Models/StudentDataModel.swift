//
//  StudentDataModel.swift
//  ClubHub
//
//  Created by Hardik on 04/11/25.
//

import Foundation

final class StudentDataModel {
    static let shared = StudentDataModel()
    private init(){}
    
    private(set) var students: [Student] = []
    private(set) var currentStudent: Student?
  
    // Add a new student
    func setCurrentStudent(_ student: Student) {
        self.currentStudent = student
    }
    func addStudent(_ student: Student) {
        students.append(student)
    }
    
    // Fetch all students
    func getAllStudents() -> [Student] {
        return students
    }
    
    // Fetch student by ID
    func getStudent(by id: String) -> Student? {
        return students.first { $0.id == id }
    }
    
    // Fetch student by email
    func getStudent(byEmail email: String) -> Student? {
        return students.first { $0.user.email == email }
    }
    
    // Update student details
    func updateStudent(_ updatedStudent: Student) {
        if let index = students.firstIndex(where: { $0.id == updatedStudent.id }) {
            students[index] = updatedStudent
        }
    }
    
    // Remove student
    func removeStudent(by id: String) {
        students.removeAll { $0.id == id }
    }
    
    func followClub(studentID: String, clubID: String) {
            guard let studentIndex = students.firstIndex(where: { $0.id == studentID }),
                  let club = ClubDataModel.shared.getClub(by: clubID) else { return }
            
            // Add club to student's following list if not already added
            if students[studentIndex].followingClubs == nil {
                students[studentIndex].followingClubs = []
            }
            if !(students[studentIndex].followingClubs?.contains(where: { $0.id == clubID }) ?? false) {
                students[studentIndex].followingClubs?.append(club)
            }

            // Also update on ClubDataModel side (add student to members list)
            ClubDataModel.shared.addMember(studentID: studentID, to: clubID)
        }

        func unfollowClub(studentID: String, clubID: String) {
            guard let studentIndex = students.firstIndex(where: { $0.id == studentID }) else { return }

            students[studentIndex].followingClubs?.removeAll(where: { $0.id == clubID })
            ClubDataModel.shared.removeMember(studentID: studentID, from: clubID)
        }
    func getFollowedClubs(for studentID: String) -> [Club] {
        guard let student = students.first(where: { $0.id == studentID }) else { return [] }
        return student.followingClubs ?? []
    }

        // For "Upcoming Events"
        func getUpcomingEvents() -> [Event] {
            guard let events = currentStudent?.registeredEvents else { return [] }
            return events.filter { $0.date >= Date() }
        }

        // For "Recent Activity"
        func getRecentActivities() -> [ActivityLog] {
            return currentStudent?.activityLogs ?? []
        }

        // For "Followed Clubs" (used in profile)
        func getFollowedClubs() -> [Club] {
            return currentStudent?.followingClubs ?? []
        }
    
    // Log a recent activity for the current student
    func logActivity(type: ActivityType, title: String) {
        guard let student = currentStudent else { return }

        // Build a new log entry
        let newLog = ActivityLog(
            id: UUID().uuidString,
            studentId: student.id,
            title:title,
            type: type,
            timestamp: Date()
        )

    }
    func registerForEvent(_ event: Event) {
        guard let student = currentStudent else { return }
        EventDataModel.shared.register(student: student, for: event)
        logActivity(type: .registered, title: "Joined Event: \(event.name)")
    }

}
