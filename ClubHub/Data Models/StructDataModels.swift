//
//  StructDataModels.swift
//  ClubHub
//
//  Created by Hardik on 04/11/25.
//

import Foundation

enum UserRole: String, Codable {
    case student
    case clubHead
}

enum EventCategory: String, Codable, CaseIterable {
    case technical
    case cultural
    case sports
    case music
    case arts
    case dance
    case literature
    case photography
    case drama
}

enum Department: String, Codable, CaseIterable {
    case BusinessSchool
    case DepartmentOfEducation
    case CollegeOfPharmacy
    case SchoolOfHealthSciences
    case SchoolOfMassCommunication
    case SchoolOfPlanningAndArchitecture
    case UniversityInstituteOfEngineeringAndTechnology
    case CollegeOfHospitalityManagement
    case CollegeOfSalesAndMarketing
    case DesignSchool
    case UniversitySchoolOfMaritimeStudies
    case SchoolOfPsychologyAndCounselling
    case LawSchool
    case UniversityCentreForDistanceAndOnlineEducation
    case InternationalCollege
}

struct User: Codable {
    let id: String
    var name: String
    var email: String
    var password: String
    var phoneNumber : String
    var role: UserRole
    var department : Department
}


// struct Student: Codable {
//     let id: String
//     var user: User
//     var rollNumber: String
//     var department: String
//     var academicYear: Int
//     var registeredEvents : [Event]?
//     var pastEvents : [Event]?
//     var badges: [Badge]?
//     var followingClubs: [Club]?
//     var qrCodeValue: String
//     var activityLogs:[ActivityLog]?
// }


struct Student: Codable {
    let id: String
    var userID: String           // 🔗 Reference to base User
    var rollNumber: String
    var department: Department
    var academicYear: Int
    var registeredEventIDs: [String]?  // 🔗 Only store event IDs
    var pastEventIDs: [String]?
    var badgeIDs: [String]?
    var followingClubIDs: [String]?
    var qrCodeValue: String
    var activityLogIDs: [String]?
}


struct Club: Codable {
    let id: String
    var name: String
    var logo: String
    var bgPoster: String
    var description: String
//    var category: EventCategory
    var createdOn: Date
    var email: String
    var websiteURL: String?
    var socialHandles: [String]?
    var eventIDs: [String]?          // 🔗 Events hosted by club
    var memberIDs: [String]?         // 🔗 Students
    var clubHeadIDs: [String]?       // 🔗 Club heads
}



// struct ClubHead: Codable {
//     let id: String
//     var user: User
//     var club : Club
// //    var clubName: String
//     var category: String
//     var position: String
//     var department : Department
//     var events: [Event]?
// }

struct ClubHead: Codable {
    let id: String
    var userID: String            // 🔗 Links to User
    var clubID: String?           // 🔗 Managed Club
    var category: String
    var position: String
    var department: Department
    var eventIDs: [String]?       // 🔗 Events created
}



struct Badge: Codable {
    let id: String
    let title: String
    let description: String
    let points: Int
    let dateEarned: Date
    let iconName: String
    let tier: Int       // 1 to 5
}


// struct Event: Codable {
//     let id: String
//     var name: String
//     var date: Date
//     var time : Date
//     var venue: String
//     var club : Club
//     var poster : String
//     var description: String
//     var registeredStudents : [Student]
//     var category: ClubCategory
//     var maxRegistrations : Int
//     var attendees: [Student]?
//     var registrationFee: Float?
//     var qrFeeImage : String
//     var departmentsAllowed : [Department]?
//     var isFeatured : Bool
// }
struct Event: Codable {
    let id: String
    var name: String
    var date: Date
    var time: Date
    var venue: String
    var clubID: String              // 🔗 Reference to Club by ID
    var poster: String
    var description: String
    var registeredStudentIDs: [String]  // 🔗 Only store Student IDs
    var category: EventCategory
    var maxRegistrations: Int
    var attendeeIDs: [String]?          // 🔗 Only store IDs
    var registrationFee: Float?
    var qrFeeImage: String
    var departmentsAllowed: [Department]?
    var isFeatured: Bool
}


enum AnnouncementType: String, Codable {
    case general = "General"
    case eventUpdate = "Event Update"
    case urgentNotice = "Urgent Notice"
    case achievement = "Achievement"
}

struct Announcement: Codable, Identifiable {
    let id: String
    var clubID: String                // 🔗 Club
    var type: AnnouncementType
    var title: String
    var message: String
    var createdAt: Date
}


enum ActivityType: String, Codable {
    case registered
    case checkedIn
    case approvedDL
    case rejectedDL
    case submittedDL
}

struct ActivityLog: Codable {
    let id: String
    let studentId: String
    var title:String
    let type: ActivityType
    let timestamp: Date
}


enum DutyLeaveStatus: String, Codable {
    case pending
    case approved
    case rejected
}

struct DutyLeave: Codable {
    let id: String
    var studentID: String             // 🔗 Student
    var eventID: String               // 🔗 Event
    var qrCodeValue: String
    var status: DutyLeaveStatus
    var createdAt: Date
}




//                                                  OLD


//import Foundation
//
//enum UserRole: String, Codable {
//    case student
//    case clubHead
//}
//enum ClubCategory: String, Codable, CaseIterable {
//    case technical
//    case cultural
//    case sports
//    case music
//    case arts
//    case dance
//    case literature
//    case photography
//    case drama
//}
//
//enum Department: String, Codable, CaseIterable {
//    case BusinessSchool
//    case DepartmentOfEducation
//    case CollegeOfPharmacy
//    case SchoolOfHealthSciences
//    case SchoolOfMassCommunication
//    case SchoolOfPlanningAndArchitecture
//    case UniversityInstituteOfEngineeringAndTechnology
//    case CollegeOfHospitalityManagement
//    case CollegeOfSalesAndMarketing
//    case DesignSchool
//    case UniversitySchoolOfMaritimeStudies
//    case SchoolOfPsychologyAndCounselling
//    case LawSchool
//    case UniversityCentreForDistanceAndOnlineEducation
//    case InternationalCollege
//}
//
//struct User: Codable {
//    let id: String
//    var name: String
//    var email: String
//    var password: String
//    var phoneNumber : String
//    var role: UserRole
//    var department : Department
//}
//
//struct Student: Codable {
//    let id: String
//    var user: User
//    var rollNumber: String
//    var department: String
//    var academicYear: Int
//    var registeredEvents : [Event]?
//    var pastEvents : [Event]?
//    var badges: [Badge]?
//    var followingClubs: [Club]?
//    var qrCodeValue: String
//    var activityLogs:[ActivityLog]?
//}
//
//struct Club: Codable {
//    let id: String
//    var logo : String
//    var bgPoster: String
//    var name: String
//    var createdOn : Date
//    var description: String
//    var events: [Event]?
//    var members: [Student]?
//    var clubheads : [ClubHead]
//    var category: ClubCategory
//    var email : String
//    var websiteUrl : String?
//    var socialHandles : [String]?
//    //    var clubHeadID: String
//}
//
//
//struct ClubHead: Codable {
//    let id: String
//    var user: User
//    var club : Club
////    var clubName: String
//    var category: String
//    var position: String
//    var department : Department
//    var events: [Event]?
//}
//
//struct Badge: Codable {
//    let id: String
//    let title: String
//    let description: String
//    let dateEarned: Date
//}
//
//struct Event: Codable {
//    let id: String
//    var name: String
//    var date: Date
//    var time : Date
//    var venue: String
//    var club : Club
//    var poster : String
//    var description: String
//    var registeredStudents : [Student]
//    var category: ClubCategory
//    var maxRegistrations : Int
//    var attendees: [Student]?
//    var registrationFee: Float?
//    var qrFeeImage : String
//    var departmentsAllowed : [Department]?
//    var isFeatured : Bool
//}
//
//enum AnnouncementType: String, Codable {
//    case general = "General"
//    case eventUpdate = "Event Update"
//    case urgentNotice = "Urgent Notice"
//    case achievement = "Achievement"
//}
//
//struct Announcement: Codable, Identifiable {
//    let id: String
//    var club : Club            // which club posted this
//    var type: AnnouncementType       // one of the 4 types
//    var title: String
//    var message: String
//    var createdAt: Date              // timestamp
//}
//
//enum ActivityType: String, Codable {
//    case registered
//    case checkedIn
//}
//
//struct ActivityLog: Codable {
//    let id: String
//    let studentId: String
//    var title:String
//    let type: ActivityType
//    let timestamp: Date
//}
//
////final class UserDataModel {
////    static let shared = UserDataModel()
////    private init() {}
////    
////    private(set) var users: [User] = []
////    
////    func addUser(_ user: User) {
////        users.append(user)
////    }
////    
////    func getAllUsers() -> [User] {
////        return users
////    }
////    
////    func getUser(by id: String) -> User? {
////        return users.first { $0.id == id }
////    }
////    
////    func getUser(byEmail email: String) -> User? {
////        return users.first { $0.email == email }
////    }
////    
////    func updateUser(_ updatedUser: User) {
////        if let index = users.firstIndex(where: { $0.id == updatedUser.id }) {
////            users[index] = updatedUser
////        }
////    }
////    
////    func removeUser(by id: String) {
////        users.removeAll { $0.id == id }
////    }
////}
//
//
////final class StudentDataModel {
////    static let shared = StudentDataModel()
////    private init() {}
////    
////    private(set) var students: [Student] = []
////    
////  
////    // Add a new student
////    func addStudent(_ student: Student) {
////        students.append(student)
////    }
////    
////    // Fetch all students
////    func getAllStudents() -> [Student] {
////        return students
////    }
////    
////    // Fetch student by ID
////    func getStudent(by id: String) -> Student? {
////        return students.first { $0.id == id }
////    }
////    
////    // Fetch student by email
////    func getStudent(byEmail email: String) -> Student? {
////        return students.first { $0.user.email == email }
////    }
////    
////    // Update student details
////    func updateStudent(_ updatedStudent: Student) {
////        if let index = students.firstIndex(where: { $0.id == updatedStudent.id }) {
////            students[index] = updatedStudent
////        }
////    }
////    
////    // Remove student
////    func removeStudent(by id: String) {
////        students.removeAll { $0.id == id }
////    }
////}
//
////final class ClubDataModel {
////    static let shared = ClubDataModel()
////    private init() {}
////    
////    private(set) var clubs: [Club] = []
////
////    
////    func getAllClubs() -> [Club] {
////        return clubs
////    }
////    
////    func getClub(by id: String) -> Club? {
////        return clubs.first { $0.id == id }
////    }
////
////}
//
////final class ClubHeadDataModel {
////    static let shared = ClubHeadDataModel()
////    private init() {}
////    
////    private(set) var clubHeads: [ClubHead] = []
////    
////    func addClubHead(_ clubHead: ClubHead) {
////        clubHeads.append(clubHead)
////    }
////    
////    func getAllClubHeads() -> [ClubHead] {
////        return clubHeads
////    }
////    
////    func getClubHead(by id: String) -> ClubHead? {
////        return clubHeads.first { $0.id == id }
////    }
////    
////    func updateClubHead(_ updatedClubHead: ClubHead) {
////        if let index = clubHeads.firstIndex(where: { $0.id == updatedClubHead.id }) {
////            clubHeads[index] = updatedClubHead
////        }
////    }
////    
////    func removeClubHead(by id: String) {
////        clubHeads.removeAll { $0.id == id }
////    }
////}
//
//
////final class EventDataModel {
////    static let shared = EventDataModel()
////    private init() {}
////    
////    private(set) var events: [Event] = []
////    
////    func addEvent(_ event: Event) {
////        events.append(event)
////    }
////    
////    func getAllEvents() -> [Event] {
////        return events
////    }
////    
////    func getEvent(by id: String) -> Event? {
////        return events.first { $0.id == id }
////    }
////    
////    /// 🔍 Get single event by exact name (case-insensitive)
////    func getEvent(byName name: String) -> Event? {
////        return events.first { $0.name.lowercased() == name.lowercased() }
////    }
////    
////    func searchEvents(containing query: String) -> [Event] {
////        guard !query.isEmpty else { return events } // return all if query empty
////        return events.filter { $0.name.lowercased().contains(query.lowercased()) }
////    }
////    
////    func updateEvent(_ updatedEvent: Event) {
////        if let index = events.firstIndex(where: { $0.id == updatedEvent.id }) {
////            events[index] = updatedEvent
////        }
////    }
////    
////    func removeEvent(by id: String) {
////        events.removeAll { $0.id == id }
////    }
////}
//
//
////final class BadgeDataModel {
////    static let shared = BadgeDataModel()
////    private init() {}
////    
////    private(set) var badges: [Badge] = []
////    
////    func addBadge(_ badge: Badge) {
////        badges.append(badge)
////    }
////    
////    func getAllBadges() -> [Badge] {
////        return badges
////    }
////    
////    func getBadge(by id: String) -> Badge? {
////        return badges.first { $0.id == id }
////    }
////    
////    func removeBadge(by id: String) {
////        badges.removeAll { $0.id == id }
////    }
////}
//
//enum DutyLeaveStatus: String, Codable {
//    case pending
//    case approved
//    case rejected
//}
//
//struct DutyLeave: Codable {
//    let id: String
//    var eventID: String            // Reference to Event.id
//    var studentID: String          // Reference to Student.id
//    var qrCodeValue: String        // same as Student.qrCodeValue
//    var status: DutyLeaveStatus
//    var createdAt: Date
//}
//
////final class DutyLeaveDataModel {
////    static let shared = DutyLeaveDataModel()
////    private init() {}
////    
////    private(set) var dutyLeaves: [DutyLeave] = []
////    
////    // MARK: - CRUD Operations
////    
////    func addDutyLeave(_ dutyLeave: DutyLeave) {
////        dutyLeaves.append(dutyLeave)
////    }
////    
////    func getAllDutyLeaves() -> [DutyLeave] {
////        return dutyLeaves
////    }
////    
////    func getDutyLeave(by id: String) -> DutyLeave? {
////        return dutyLeaves.first { $0.id == id }
////    }
////    
////    func removeDutyLeave(by id: String) {
////        dutyLeaves.removeAll { $0.id == id }
////    }
////    
////    // MARK: - Filter Functions
////    
////    func getDutyLeaves(forStudentID studentID: String) -> [DutyLeave] {
////        return dutyLeaves.filter { $0.studentID == studentID }
////    }
////    
////    func getDutyLeaves(forEventID eventID: String) -> [DutyLeave] {
////        return dutyLeaves.filter { $0.eventID == eventID }
////    }
////    
////    func getPendingDutyLeaves() -> [DutyLeave] {
////        return dutyLeaves.filter { $0.status == .pending }
////    }
////    
////    func getApprovedDutyLeaves() -> [DutyLeave] {
////        return dutyLeaves.filter { $0.status == .approved }
////    }
////    
////    func getRejectedDutyLeaves() -> [DutyLeave] {
////        return dutyLeaves.filter { $0.status == .rejected }
////    }
////    
////    // MARK: - Status Update Functions
////    
////    func approveDutyLeave(by id: String) {
////        if let index = dutyLeaves.firstIndex(where: { $0.id == id }) {
////            dutyLeaves[index].status = .approved
////        }
////    }
////    
////    func rejectDutyLeave(by id: String) {
////        if let index = dutyLeaves.firstIndex(where: { $0.id == id }) {
////            dutyLeaves[index].status = .rejected
////        }
////    }
////    
////    // MARK: - Create Duty Leave from Scan
////    
////    func createDutyLeaveFromScan(studentID: String, eventID: String, qrValue: String) {
////        let newDutyLeave = DutyLeave(
////            id: UUID().uuidString,
////            eventID: eventID,
////            studentID: studentID,
////            qrCodeValue: qrValue,
////            status: .pending,
////            createdAt: Date()
////        )
////        addDutyLeave(newDutyLeave)
////    }
////}
////
