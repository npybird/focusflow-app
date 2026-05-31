//
//  TaskRowView.swift
//  FocusFlowApp
//
//  Created by Natchanon Posayaanuwat on 31/5/2569 BE.
//

import SwiftUI

struct TaskRowView: View {
    let task: TaskItem
    let onToggle: () -> Void
    let onDelete: () -> Void
    let onTap: () -> Void
    
    var body: some View {
        HStack(spacing: 14) {
            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
                    onToggle()
                }
            } label: {
                Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .scaleEffect(task.isDone ? 1.15 : 1)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(task.title)
                    .font(.headline)
                    .strikethrough(task.isDone)
                    .foregroundStyle(task.isDone ? .gray : .primary)
                
                if !task.note.isEmpty {
                    Text(task.note)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                
                HStack {
                    Label(task.priority.rawValue, systemImage: task.priority.icon)
                    
                    Text(task.dueDate, style: .date)
                    
                    if !task.dueStatus.isEmpty {
                        Text(task.dueStatus)
                            .font(.caption2.bold())
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(task.dueColor.opacity(0.15))
                            .foregroundStyle(task.dueColor)
                            .clipShape(Capsule())
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button(role: .destructive) {
                withAnimation {
                    onDelete()
                }
            } label: {
                Image(systemName: "trash")
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .padding(.horizontal)
        .onTapGesture {
            onTap()
        }
    }
}
