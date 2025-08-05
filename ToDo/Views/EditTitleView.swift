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
            
            Button {
                Task {
                    await viewModel.edit(task, newTodo: viewModel.titleInput)
                }
                dismiss()
            } label: {
                Text("Сохранить")
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(.yellow)
                    .foregroundStyle(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding()
    }
}

