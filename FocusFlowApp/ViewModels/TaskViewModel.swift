//
//  TaskViewModel.swift
//  FocusFlowApp
//
//  Created by Natchanon Posayaanuwat on 31/5/2569 BE.
//

import Foundation
import Combine

enum TaskFilter: String, CaseIterable {
    case all = "All"
    case active = "Active"
    case done = "Done"
}

class TaskViewModel: ObservableObject {
    @Published var tasks: [TaskItem] = [] {
        didSet {
            saveTasks()
        }
    }
    
    @Published var selectedFilter: TaskFilter = .all
    
    private let saveKey = "focus_flow_tasks"
    
    init() {
        loadTasks()
    }
    
    var filteredTasks: [TaskItem] {
        let filtered: [TaskItem]

        switch selectedFilter {
        case .all:
            filtered = tasks
        case .active:
            filtered = tasks.filter { !$0.isDone }
        case .done:
            filtered = tasks.filter { $0.isDone }
        }

        return filtered.sorted {
            if $0.isDone != $1.isDone {
                return !$0.isDone
            }

            if $0.dueSortValue != $1.dueSortValue {
                return $0.dueSortValue < $1.dueSortValue
            }

            if $0.priority.sortValue != $1.priority.sortValue {
                return $0.priority.sortValue < $1.priority.sortValue
            }

            return $0.dueDate < $1.dueDate
        }
    }
    
    var completedCount: Int {
        tasks.filter { $0.isDone }.count
    }
    
    var progress: Double {
        guard !tasks.isEmpty else {
            return 0
        }
        
        return Double(completedCount) / Double(tasks.count)
    }
    
    func addTask(title: String, note: String, dueDate: Date, priority: TaskPriority) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedTitle.isEmpty else {
            return
        }
        
        let newTask = TaskItem(
            title: trimmedTitle,
            note: note,
            dueDate: dueDate,
            priority: priority
        )
        
        tasks.insert(newTask, at: 0)
    }
    
    func toggleTask(_ task: TaskItem) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else {
            return
        }
        
        tasks[index].isDone.toggle()
    }
    
    func deleteTask(_ task: TaskItem) {
        tasks.removeAll { $0.id == task.id }
    }
    
    func updateTask(_ updatedTask: TaskItem) {
        guard let index = tasks.firstIndex(where: { $0.id == updatedTask.id }) else {
            return
        }
        
        tasks[index] = updatedTask
    }
    
    private func saveTasks() {
        if let encodedData = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encodedData, forKey: saveKey)
        }
    }
    
    private func loadTasks() {
        guard let savedData = UserDefaults.standard.data(forKey: saveKey) else {
            tasks = sampleTasks
            return
        }
        
        if let decodedTasks = try? JSONDecoder().decode([TaskItem].self, from: savedData) {
            tasks = decodedTasks
        }
    }
    
    private var sampleTasks: [TaskItem] {
        [
            TaskItem(
                title: "Buy groceries",
                note: "Buy eggs, milk, and cheese.",
                priority: .medium,
            ),
            TaskItem(
                title: "Buy my girl a flower",
                note: "At Pak Klong Talad.",
                priority: .high
            ),
            TaskItem(
                title: "Send CN436 final project",
                note: "Send by 11.59 PM.",
                priority: .high
            ),
            TaskItem(
                title: "Go for a run",
                note: "At Benjakitti Park.",
                priority: .low
            ),
            TaskItem(
                title: "Do laundry",
                note: "Separate whites and colors.",
                priority: .medium
            ),
        ]
    }
}
