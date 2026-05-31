//
//  TaskItem.swift
//  FocusFlowApp
//
//  Created by Natchanon Posayaanuwat on 31/5/2569 BE.
//

import Foundation
import SwiftUI

enum TaskPriority: String, Codable, CaseIterable, Identifiable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .low: return "leaf.fill"
        case .medium: return "flame.fill"
        case .high: return "exclamationmark.triangle.fill"
        }
    }
    
    var sortValue: Int {
        switch self {
        case .high:
            return 0
        case .medium:
            return 1
        case .low:
            return 2
        }
    }
}

struct TaskItem: Codable, Identifiable {
    let id: UUID
    var title: String
    var note: String
    var dueDate: Date
    var priority: TaskPriority
    var isDone: Bool
    
    var dueStatus: String {
        let calendar = Calendar.current
        
        if calendar.isDateInToday(dueDate) {
            return "Today"
        } else if calendar.isDateInTomorrow(dueDate) {
            return "Tomorrow"
        } else if dueDate < Date() && !calendar.isDateInToday(dueDate) {
            return "Overdue"
        } else {
            return ""
        }
    }
    
    var dueColor: Color {
        switch dueStatus {
        case "Today":
            return .blue
        case "Tomorrow":
            return .green
        case "Overdue":
            return .red
        default:
            return .gray
        }
    }
    
    var dueSortValue: Int {
        let calendar = Calendar.current
        
        if dueDate < Date() && !calendar.isDateInToday(dueDate) {
            return 0
        } else if calendar.isDateInToday(dueDate) {
            return 1
        } else if calendar.isDateInTomorrow(dueDate) {
            return 2
        } else {
            return 3
        }
    }
    
    init(
        id: UUID = UUID(),
        title: String,
        note: String = "",
        dueDate: Date = Date(),
        priority: TaskPriority = .medium,
        isDone: Bool = false
    ) {
        self.id = id
        self.title = title
        self.note = note
        self.dueDate = dueDate
        self.priority = priority
        self.isDone = isDone
    }
}
