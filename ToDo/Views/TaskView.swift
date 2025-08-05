//
//  TaskView.swift
//  ToDo
//
//  Created by metalWillHelpYou on 04.08.2025.
//

import SwiftUI

struct TaskView: View {
    @ObservedObject var viewModel: TaskViewModel
    @ObservedObject var task: TaskEntity
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                HStack{
                    Text(task.todo ?? "Unknown")
                        .font(.system(size: 34, weight: .heavy))
                    Spacer()
                }
                
                Text(viewModel.formatDateForDisplay(task.timestamp))
                    .foregroundStyle(.gray)
                
                TextField("", text: Binding(
                    get: { task.content ?? "" },
                    set: { newValue in
                        task.content = newValue
                        viewModel.saveData()
                    }
                ))
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
        .padding(.horizontal)
    }
}
