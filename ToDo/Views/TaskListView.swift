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
    @State private var taskForEditing: TaskEntity?
    
    var body: some View {
        NavigationStack {
            List(viewModel.filteredTasks) { task in
                HStack(alignment: .top) {
                    Button {
                        viewModel.toggleCompleteStatus(for: task)
                    } label: {
                        Image(systemName: task.completed ? "checkmark.circle" : "circle")
                            .resizable()
                            .frame(width: 24, height: 24)
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
            .sheet(item: $taskForEditing) { task in
                EditTitleView(viewModel: viewModel, task: task)
                    .presentationDetents([.medium])
            }
            .listStyle(.plain)
            .navigationTitle("Задачи")
            .searchable(text: $viewModel.searchText, prompt: "Search")
            .navigationDestination(item: $viewModel.selectedTask) { task in
                TaskView(viewModel: viewModel, task: task)
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    ZStack {
                        Text("\(viewModel.savedTasks.count) \(viewModel.taskWord(for: viewModel.savedTasks.count))")
                            .font(.caption)
                        
                        HStack {
                            Spacer()
                            Button(action: {
                                
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
        VStack(alignment: .leading, spacing: 16) {
            Text(task.todo ?? "Без названия")
                .font(.title2)
                .strikethrough(task.completed, color: .gray)
                .foregroundColor(task.completed ? .gray : .primary)
            
            Text(viewModel.formatDateForDisplay(task.timestamp))
                .foregroundStyle(.gray)
        }
    }
}

#Preview {
    TaskListView()
}
