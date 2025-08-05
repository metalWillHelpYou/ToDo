//
//  TaskView.swift
//  ToDo
//
//  Created by metalWillHelpYou on 04.08.2025.
//

import SwiftUI

struct TaskView: View {
    @ObservedObject var viewModel: TaskViewModel
    let task: TaskEntity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack{
                Text(task.todo ?? "Unknown")
                    .font(.system(size: 34, weight: .heavy))
                Spacer()
            }
            Text(viewModel.formatDateForDisplay(task.timestamp))
                .foregroundStyle(.gray)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
        .padding(.horizontal)
    }
}

