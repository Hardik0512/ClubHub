//
//  Date+Extensions.swift
//  ClubHub
//
//  Created by Hardik on 17/11/25.
//

import Foundation

extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))

        if secondsAgo < 60 {
            return "just now"
        } else if secondsAgo < 3600 {
            return "\(secondsAgo / 60) min ago"
        } else if secondsAgo < 86400 {
            return "\(secondsAgo / 3600) hr ago"
        } else if secondsAgo < 172800 {
            return "yesterday"
        } else {
            return "\(secondsAgo / 86400) days ago"
        }
    }
}
