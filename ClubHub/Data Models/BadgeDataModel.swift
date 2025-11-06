//
//  BadgeDataModel.swift
//  ClubHub
//
//  Created by Hardik on 04/11/25.
//

import Foundation

final class BadgeDataModel {
    static let shared = BadgeDataModel()
    private init() {}
    
    private(set) var badges: [Badge] = []
    
    func addBadge(_ badge: Badge) {
        badges.append(badge)
    }
    
    func getAllBadges() -> [Badge] {
        return badges
    }
    
    func getBadge(by id: String) -> Badge? {
        return badges.first { $0.id == id }
    }
    
    func removeBadge(by id: String) {
        badges.removeAll { $0.id == id }
    }
}
