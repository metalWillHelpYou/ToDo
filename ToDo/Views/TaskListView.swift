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
                taskRow(for: task)
                    .accessibilityIdentifier("taskRow_\(task.id ?? "")")
            }
            .listStyle(.plain)
            .navigationTitle("Задачи")
            .searchable(text: $viewModel.searchText, prompt: "Поиск")
            .navigationDestination(item: $viewModel.selectedTask) { task in
                TaskView(viewModel: viewModel, task: task)
            }
            .sheet(isPresented: $showAddView) {
                AddTitleView(viewModel: viewModel)
                    .presentationDetents([.fraction(0.2)])
                    .presentationDragIndicator(.visible)
            }
            .sheet(item: $taskForEditing) { task in
                EditTitleView(viewModel: viewModel, task: task)
                    .presentationDetents([.fraction(0.2)])
                    .presentationDragIndicator(.visible)
            }
            .toolbar { bottomToolbar }
        }
    }
}

extension TaskListView {
    private func taskRow(for task: TaskEntity) -> some View {
        HStack {
            completionToggleButton(for: task)
            taskCard(for: task)
                .onTapGesture { viewModel.selectedTask = task }
        }
        .contextMenu { contextMenu(for: task) }
    }

    private func completionToggleButton(for task: TaskEntity) -> some View {
        VStack {
            Button {
                withAnimation(.spring) {
                    viewModel.toggleCompleteStatus(for: task)
                }
            } label: {
                Image(task.completed ? "yellowCheckmark" : "circle")
                    .foregroundStyle(task.completed ? .yellow : .primary)
                    .padding(.trailing, 2)
            }
            Spacer()
        }
    }

    private func taskCard(for task: TaskEntity) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(task.todo ?? "Без названия")
                .font(.title2)
                .strikethrough(task.completed, color: .gray)
                .foregroundColor(task.completed ? .gray : .primary)
                .accessibilityIdentifier("taskTitle_\(task.id ?? "")")


            if let content = task.content, !content.isEmpty {
                Text(content)
                    .foregroundStyle(task.completed ? .gray : .primary)
            }

            Text(viewModel.formatDateForDisplay(task.timestamp))
                .foregroundStyle(.gray)
        }
    }
}

extension TaskListView {
    private func contextMenu(for task: TaskEntity) -> some View {
        Group {
            Button {
                taskForEditing = task
                showEditView = true
            } label: {
                Label("Редактировать", systemImage: "pencil")
            }
            .accessibilityIdentifier("editTaskButton")

            Button {
            } label: {
                Label("Поделиться", systemImage: "square.and.arrow.up")
            }
            .accessibilityIdentifier("addTaskButton")

            Button(role: .destructive) {
                Task {
                    await viewModel.delete(task)
                }
            } label: {
                Label("Удалить", systemImage: "trash")
            }
            .accessibilityIdentifier("deleteTaskButton")
        }
    }

    private var bottomToolbar: some ToolbarContent {
        ToolbarItem(placement: .bottomBar) {
            ZStack {
                Text("\(viewModel.savedTasks.count) \(viewModel.taskWord(for: viewModel.savedTasks.count))")
                    .font(.caption)

                HStack {
                    Spacer()
                    Button {
                        showAddView.toggle()
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.yellow)
                    }
                    .accessibilityIdentifier("addTaskButton")
                }
            }
        }
    }
}

#Preview {
    TaskListView()
}
