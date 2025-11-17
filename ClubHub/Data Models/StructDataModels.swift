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

struct Student: Codable {
    let id: String
    var userID: String
    var rollNumber: String
    var department: Department
    var academicYear: Int
    var registeredEventIDs: [String]?
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
    var createdOn: Date
    var email: String
    var websiteURL: String?
    var socialHandles: [String]?
    var eventIDs: [String]?
    var memberIDs: [String]?
    var clubHeadIDs: [String]?
}


struct ClubHead: Codable {
    let id: String
    var userID: String
    var clubID: String
    var category: String
    var position: String
    var department: Department
    var eventIDs: [String]?
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
    var registeredStudentIDs: [String] = []  // 🔗 Only store Student IDs (non-optional)
    var checkedInStudentIDs: [String] = []   // 🔗 Only store CheckedIn Student IDs (non-optional)
    var category: EventCategory
    var maxRegistrations: Int
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
    var clubID: String
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
    var studentID: String
    var eventID: String              
    var qrCodeValue: String
    var status: DutyLeaveStatus
    var createdAt: Date
}
