//
//  TaskListView.swift
//  ToDo
//
//  Created by metalWillHelpYou on 04.08.2025.
//

import SwiftUI

struct TaskListView: View {
    @StateObject private var viewModel = TaskViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.savedTasks) { task in
                    HStack(alignment: .top) {
                        Button {
                            
                        } label: {
                            Image(systemName: task.completed ? "checkmark.circle" : "circle")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(task.completed ? .yellow : .primary)
                                .padding(.trailing, 2)
                        }
                        
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
                .listStyle(.plain)
            }
            .navigationTitle("Список задач")
            .toolbar(.visible, for: .bottomBar)
            .toolbar(.visible, for: .bottomBar)
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

#Preview {
    TaskListView()
}
