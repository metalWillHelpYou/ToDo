//
//  TaskListView.swift
//  ToDo
//
//  Created by metalWillHelpYou on 04.08.2025.
//

import SwiftUI

struct TaskListView: View {
    @StateObject private var viewModel = TaskViewModel()
    @State private var showEditView = false
    @State private var showAddView = false
    @State private var taskForEditing: TaskEntity?
    
    var body: some View {
        NavigationStack {
            List(viewModel.filteredTasks) { task in
                HStack(alignment: .top) {
                    Button {
                        withAnimation(.spring(duration: 0.2)) {
                            viewModel.toggleCompleteStatus(for: task)
                        }
                    } label: {
                        Image(task.completed ? "yellowCheckmark" : "circle")
                            .foregroundStyle(task.completed ? .yellow : .primary)
                            .padding(.trailing, 2)
                    }
                    
                    taskCardfor(task)
                        .onTapGesture { viewModel.selectedTask = task }
                }
                .contextMenu {
                    Button {
                        taskForEditing = task
                        showEditView.toggle()
                    } label: {
                        Label("Редактировать", systemImage: "pencil")
                    }
                    
                    Button {

                    } label: {
                        Label("Поделиться", image: "export")
                    }
                    
                    Button(role: .destructive) {
                        viewModel.delete(task)
                    } label: {
                        Label("Удалить", systemImage: "trash")
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Задачи")
            .searchable(text: $viewModel.searchText, prompt: "Search")
            .navigationDestination(item: $viewModel.selectedTask) { task in
                TaskView(viewModel: viewModel, task: task)
            }
            .sheet(isPresented: $showAddView, content: {
                AddTitleView(viewModel: viewModel)
                    .presentationDetents([.fraction(0.2)])
                    .presentationDragIndicator(.visible)
            })
            .sheet(item: $taskForEditing) { task in
                EditTitleView(viewModel: viewModel, task: task)
                    .presentationDetents([.fraction(0.2)])
                    .presentationDragIndicator(.visible)
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    ZStack {
                        Text("\(viewModel.savedTasks.count) \(viewModel.taskWord(for: viewModel.savedTasks.count))")
                            .font(.caption)
                        
                        HStack {
                            Spacer()
                            Button(action: {
                                showAddView.toggle()
                            }) {
                                Image(systemName: "square.and.pencil")
                                    .foregroundColor(.yellow)
                            }
                        }
                    }
                }
            }
        }
    }
}

extension TaskListView {
    private func taskCardfor(_ task: TaskEntity) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(task.todo ?? "Без названия")
                .font(.title2)
                .strikethrough(task.completed, color: .gray)
                .foregroundColor(task.completed ? .gray : .primary)
            
            if let content = task.content {
                Text(content)
                    .foregroundStyle(task.completed ? .gray : .white)
            }
            
            Text(viewModel.formatDateForDisplay(task.timestamp))
                .foregroundStyle(.gray)
        }
    }
}

#Preview {
    TaskListView()
}
