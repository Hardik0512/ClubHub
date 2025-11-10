//
//  ActivityLogDataModel.swift
//  ClubHub
//
//  Created by Hardik on 10/11/25.
//

import Foundation

final class ActivityLogDataModel {
    static let shared = ActivityLogDataModel()
    private init() {}

    private(set) var activityLogs: [ActivityLog] = []

    func addActivity(_ activity: ActivityLog) {
        activityLogs.insert(activity, at: 0) // insert at top for recent display
    }

    func getActivityLogs(for studentId: String) -> [ActivityLog] {
        return activityLogs.filter { $0.studentId == studentId }
    }
}
