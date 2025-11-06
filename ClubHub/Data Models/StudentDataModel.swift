//
//  StudentDataModel.swift
//  ClubHub
//
//  Created by Hardik on 04/11/25.
//

import Foundation

final class StudentDataModel {
    static let shared = StudentDataModel()
    private init() {}
    
    private(set) var students: [Student] = []
    
  
    // Add a new student
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
}
