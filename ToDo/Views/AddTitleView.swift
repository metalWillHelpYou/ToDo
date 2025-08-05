//
//  AddTitleView.swift
//  ToDo
//
//  Created by metalWillHelpYou on 05.08.2025.
//

import SwiftUI

struct AddTitleView: View {
    @ObservedObject var viewModel: TaskViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            TextField("New toDo", text: $viewModel.titleInput)                
                .padding(8)
                .background(.gray)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Button {
                viewModel.addTask(todo: viewModel.titleInput)
                dismiss()
            } label: {
                Text("Добавить")
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
