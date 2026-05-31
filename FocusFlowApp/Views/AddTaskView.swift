//
//  AddTaskView.swift
//  FocusFlowApp
//
//  Created by Natchanon Posayaanuwat on 31/5/2569 BE.
//

import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: TaskViewModel
    
    @State private var title = ""
    @State private var note = ""
    @State private var dueDate = Date()
    @State private var priority: TaskPriority = .medium

    var body: some View {
        NavigationStack {
            Form {
                Section("Task Info") {
                    TextField("Task Title", text: $title)
                    TextField("Additional Note", text: $note)
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
            }
            .navigationTitle("New Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.addTask(title: title, note: note, dueDate: dueDate, priority: priority)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
