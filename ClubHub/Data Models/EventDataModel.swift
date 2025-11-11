//
//  EventDataModel.swift
//  ClubHub
//
//  Created by Hardik on 04/11/25.
//

import Foundation

class EventDataModel {
    static let shared = EventDataModel()
    private init() { loadFromPlist() }

    private(set) var events: [Event] = []

    // MARK: - CRUD Methods
    func addEvent(_ event: Event) {
        events.append(event)
        saveToPlist()
    }

    func getAllEvents() -> [Event] {
        return events
    }

    func getEvent(by id: String) -> Event? {
        return events.first { $0.id == id }
    }

    func getEvent(byName name: String) -> Event? {
        return events.first { $0.name.lowercased() == name.lowercased() }
    }

    func getEvents(for category: EventCategory) -> [Event] {
        return events.filter { $0.category == category }
    }

    func searchEvents(containing query: String) -> [Event] {
        guard !query.isEmpty else { return events }
        return events.filter { $0.name.lowercased().contains(query.lowercased()) }
    }

    func getEventFeed() -> [Event] {
        return events.sorted { $0.date < $1.date }
    }

    func getTodayEvents() -> [Event] {
        let today = Calendar.current.startOfDay(for: Date())
        return events.filter { Calendar.current.isDate($0.date, inSameDayAs: today) }
    }

    func getFeaturedEvents() -> [Event] {
        return events.filter { $0.isFeatured }
    }

    func updateEvent(_ updatedEvent: Event) {
        if let index = events.firstIndex(where: { $0.id == updatedEvent.id }) {
            events[index] = updatedEvent
            saveToPlist()
        }
    }
    func getEvents(byIDs ids: [String]) -> [Event] {
    return events.filter { ids.contains($0.id) }
}


    func removeEvent(by id: String) {
        events.removeAll { $0.id == id }
        saveToPlist()
    }

    // MARK: - Registration Handling
    func register(studentID: String, for eventID: String) {
        guard let index = events.firstIndex(where: { $0.id == eventID }) else { return }
        if !events[index].registeredStudentIDs.contains(studentID) {
            events[index].registeredStudentIDs.append(studentID)
            saveToPlist()
        }
    }

    func isRegistered(studentID: String, for eventID: String) -> Bool {
        guard let event = getEvent(by: eventID) else { return false }
        return event.registeredStudentIDs.contains(studentID)
    }

    // MARK: - Persistence
    private var plistURL: URL {
        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docDir.appendingPathComponent("Events.plist")
    }

    func saveToPlist() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(events)
            try data.write(to: plistURL)
        } catch {
            print("❌ Error saving events: \(error)")
        }
    }

    func loadFromPlist() {
        let decoder = PropertyListDecoder()
        do {
            let data = try Data(contentsOf: plistURL)
            events = try decoder.decode([Event].self, from: data)
        } catch {
            print("⚠️ No saved events found or error loading: \(error)")
        }
    }
}

