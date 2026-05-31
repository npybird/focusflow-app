//
//  ContentView.swift
//  FocusFlowApp
//
//  Created by Natchanon Posayaanuwat on 31/5/2569 BE.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TaskViewModel()
    @State private var showingAddTask = false
    @State private var selectedTask: TaskItem?
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [.blue.opacity(0.18), .purple.opacity(0.12)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    headerView
                    
                    filterView
                    
                    ZStack {
                        if viewModel.filteredTasks.isEmpty {
                            emptyStateView
                                .transition(
                                    .asymmetric(
                                        insertion: .opacity.combined(with: .scale(scale: 0.96)),
                                        removal: .opacity.combined(with: .scale(scale: 1.04))
                                    )
                                )
                        } else {
                            ScrollView {
                                LazyVStack(spacing: 12) {
                                    ForEach(viewModel.filteredTasks) { task in
                                        TaskRowView(
                                            task: task,
                                            onToggle: {
                                                viewModel.toggleTask(task)
                                            },
                                            onDelete: {
                                                viewModel.deleteTask(task)
                                            },
                                            onTap: {
                                                selectedTask = task
                                            }
                                        )
                                        .transition(
                                            .asymmetric(
                                                insertion: .opacity.combined(with: .move(edge: .trailing)),
                                                removal: .opacity.combined(with: .move(edge: .leading))
                                            )
                                        )
                                    }
                                }
                                .padding(.bottom, 90)
                            }
                            .transition(
                                .asymmetric(
                                    insertion: .opacity.combined(with: .move(edge: .trailing)),
                                    removal: .opacity.combined(with: .move(edge: .leading))
                                )
                            )
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .animation(.spring(
                        response: 0.38,
                        dampingFraction: 0.86),
                        value: viewModel.selectedFilter
                    )
                    .animation(.spring(
                        response: 0.38,
                        dampingFraction: 0.86),
                               value: viewModel.filteredTasks.count
                    )
                }
                
                VStack {
                    Spacer()
                    
                    Button {
                        showingAddTask = true
                    } label: {
                        Label("Add Task", systemImage: "plus")
                            .font(.headline)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 14)
                            .background(.blue)
                            .foregroundStyle(.white)
                            .clipShape(Capsule())
                            .shadow(radius: 10)
                    }
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Focus Flow")
            .sheet(isPresented: $showingAddTask) {
                AddTaskView(viewModel: viewModel)
            }
            .sheet(item: $selectedTask) { task in
                    TaskDetailView(viewModel: viewModel, task: task)
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Today's Progress 📈")
                    .font(.title2.bold())
                
                Text("\(viewModel.completedCount) of \(viewModel.tasks.count) task completed 🎉")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            ProgressRingView(progress: viewModel.progress)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .padding(.horizontal)
        .padding(.top, 12)
    }
    
    private var filterView: some View {
        Picker("Filter", selection: $viewModel.selectedFilter) {
            ForEach(TaskFilter.allCases, id: \.self) { filter in
                Text(filter.rawValue).tag(filter)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
        .onChange(of: viewModel.selectedFilter) {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                viewModel.selectedFilter = viewModel.selectedFilter
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "sparkles")
                .font(.system(size: 56))
                .foregroundStyle(.blue)
            
            Text("No tasks here! 😎")
                .font(.title2.bold())
            
            Text("Add new task to start managing your days! 🚀")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 80)
    }
}

#Preview {
    ContentView()
}
