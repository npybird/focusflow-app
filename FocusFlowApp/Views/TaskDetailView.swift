//
//  TaskDetailView.swift
//  FocusFlowApp
//
//  Created by Natchanon Posayaanuwat on 31/5/2569 BE.
//

import SwiftUI

struct TaskDetailView: View {
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var viewModel: TaskViewModel
    let task: TaskItem

    @State private var title: String
    @State private var note: String
    @State private var dueDate: Date
    @State private var priority: TaskPriority
    @State private var isDone: Bool

    init(viewModel: TaskViewModel, task: TaskItem) {
        self.viewModel = viewModel
        self.task = task

        _title = State(initialValue: task.title)
        _note = State(initialValue: task.note)
        _dueDate = State(initialValue: task.dueDate)
        _priority = State(initialValue: task.priority)
        _isDone = State(initialValue: task.isDone)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Task Info") {
                    TextField("Task title", text: $title)
                    TextField("Note", text: $note)
                }

                Section("Schedule") {
                    DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                }

                Section("Priority") {
                    Picker("Priority", selection: $priority) {
                        ForEach(TaskPriority.allCases) { item in
                            Label(item.rawValue, systemImage: item.icon)
                                .tag(item)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Status") {
                    Toggle("Completed", isOn: $isDone)
                }
            }
            .navigationTitle("Edit Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let updatedTask = TaskItem(
                            id: task.id,
                            title: title,
                            note: note,
                            dueDate: dueDate,
                            priority: priority,
                            isDone: isDone
                        )

                        viewModel.updateTask(updatedTask)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
