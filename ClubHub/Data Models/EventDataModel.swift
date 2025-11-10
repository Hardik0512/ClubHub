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
    func getEvent(for category:ClubCategory)->[Event]{
        return events.filter { $0.category == category }
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
    func getEventFeed() -> [Event] {
        return events.sorted{$0.date<$1.date}
    }
    
    func removeEvent(by id: String) {
        events.removeAll { $0.id == id }
    }
    
    func getTodayEvents() -> [Event] {
            let today = Calendar.current.startOfDay(for: Date())
            return events.filter {
                Calendar.current.isDate($0.date, inSameDayAs: today)
            }
        }
        
        func getFeaturedEvents() -> [Event] {
            return events.filter { $0.isFeatured }
        }
        
        func register(student: Student, for event: Event) {
            guard let index = events.firstIndex(where: { $0.id == event.id }) else { return }
            if !events[index].registeredStudents.contains(where: {$0.id == student.id}) {
                events[index].registeredStudents.append(student)
            }
        }
        
        func isRegistered(student: Student, for event: Event) -> Bool {
            event.registeredStudents.contains(where: {$0.id == student.id})
        }
}
