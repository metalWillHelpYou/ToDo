//
//  EditTitleView.swift
//  ToDo
//
//  Created by metalWillHelpYou on 05.08.2025.
//

import SwiftUI

struct EditTitleView: View {
    @ObservedObject var viewModel: TaskViewModel
    
    var task: TaskEntity
    
    var body: some View {
        VStack {
            TextField("new title", text: $viewModel.titleInput)                .padding()
                .background(.gray)
            
            Button {
                viewModel.edit(task, newTodo: viewModel.titleInput)
            } label: {
                Text("Сохранить")
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(.yellow)
                    .foregroundStyle(.black)
            }
        }
        .padding()
    }
}

