//
//  EventDataModel.swift
//  ClubHub
//
//  Created by Hardik on 04/11/25.
//

import Foundation

final class EventDataModel {
    static let shared = EventDataModel()
    private init() {}
    
    private(set) var events: [Event] = []
    
    func addEvent(_ event: Event) {
        events.append(event)
    }
    
    func getAllEvents() -> [Event] {
        return events
    }
    
    func getEvent(by id: String) -> Event? {
        return events.first { $0.id == id }
    }
    
    /// 🔍 Get single event by exact name (case-insensitive)
    func getEvent(byName name: String) -> Event? {
        return events.first { $0.name.lowercased() == name.lowercased() }
    }
    
    func searchEvents(containing query: String) -> [Event] {
        guard !query.isEmpty else { return events } // return all if query empty
        return events.filter { $0.name.lowercased().contains(query.lowercased()) }
    }
    
    func updateEvent(_ updatedEvent: Event) {
        if let index = events.firstIndex(where: { $0.id == updatedEvent.id }) {
            events[index] = updatedEvent
        }
    }
    
    func removeEvent(by id: String) {
        events.removeAll { $0.id == id }
    }
}
