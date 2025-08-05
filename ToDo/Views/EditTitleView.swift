//
//  EditTitleView.swift
//  ToDo
//
//  Created by metalWillHelpYou on 05.08.2025.
//

import SwiftUI

struct EditTitleView: View {
    @ObservedObject var viewModel: TaskViewModel
    @Environment(\.dismiss) var dismiss
    
    var task: TaskEntity
    
    var body: some View {
        VStack {
            TextField("New title", text: $viewModel.titleInput)                
                .padding(8)
                .background(.gray)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .accessibilityIdentifier("editTaskInputField")
            
            Button {
                viewModel.edit(task, newTodo: viewModel.titleInput)
                dismiss()
            } label: {
                Text("Сохранить")
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(viewModel.titleInput.isEmpty ? Color.black.opacity(0.3) : Color.black)
                    .background(viewModel.titleInput.isEmpty ? Color.yellow.opacity(0.3) : Color.yellow)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .animation(.easeInOut(duration: 0.3), value: viewModel.titleInput)
            }
        }
        .padding()
    }
}

