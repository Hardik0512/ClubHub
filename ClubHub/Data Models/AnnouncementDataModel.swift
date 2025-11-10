//
//  AnnouncementDataModel.swift
//  ClubHub
//
//  Created by Hardik on 10/11/25.
//

import Foundation

final class AnnoncementDataModel: Codable {
    static let shared = AnnoncementDataModel()
    private init(){}
    private(set) var announcements: [Announcement] = []
   func addAnnouncement(_ announcement: Announcement){
        announcements.append(announcement)
    }
    func getAllAnnouncements()-> [Announcement]{
        return announcements
    }
    
    func getAnnouncement(by id: String)-> Announcement?{
        return announcements.first{$0.id == id}
    }
    func removeAnnouncement(by id: String){
        announcements.removeAll(where: {$0.id == id})
    }
    
}
