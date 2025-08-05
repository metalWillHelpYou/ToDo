//
//  TaskViewModel.swift
//  ToDo
//
//  Created by metalWillHelpYou on 04.08.2025.
//

import Foundation
import CoreData

@MainActor
final class TaskViewModel: ObservableObject {
    let container: NSPersistentContainer
    @Published var selectedTask: TaskEntity?
    @Published var savedTasks: [TaskEntity] = []
    @Published var searchText: String = ""
    @Published var titleInput: String = ""
    
    init() {
        container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("\(error.localizedDescription)")
            }
        }
        
        fetchTasks()
        importFromAPIIfNeeded()
    }
    
    func fetchTasks() {
        let request = NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
        let sort = NSSortDescriptor(key: "timestamp", ascending: true)
        request.sortDescriptors = [sort]
        do {
            savedTasks = try container.viewContext.fetch(request)
        } catch  {
            print("Error: \(error)")
        }
    }

    func addTask(todo: String) {
        guard !todo.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let newTask = TaskEntity(context: container.viewContext)
        newTask.todo = todo
        newTask.completed = false
        newTask.timestamp = Date()
        newTask.id = UUID().uuidString
        saveData()
    }

    
    func edit(_ task: TaskEntity, newTodo: String) {
        guard !newTodo.isEmpty else { return }
        task.todo = newTodo
        titleInput = ""
        saveData()
    }

    func delete(_ task: TaskEntity) {
        container.viewContext.delete(task)
        saveData()
    }

    func saveData() {
        do {
            try container.viewContext.save()
            fetchTasks()
        } catch {
            print("\(error.localizedDescription)")
        }
    }
    
    func toggleCompleteStatus(for task: TaskEntity) {
        task.completed.toggle()
        saveData()
    }
    
    func importFromAPIIfNeeded() {
        let alreadyImported = UserDefaults.standard.bool(forKey: "didImportInitialTodos")
        guard !alreadyImported else { return }
        
        Task {
            do {
                let todos = try await fetchTodosFromAPI()
                await MainActor.run {
                    for todo in todos {
                        let task = TaskEntity(context: container.viewContext)
                        task.id = UUID().uuidString
                        task.todo = todo.todo
                        task.completed = todo.completed
                        task.userId = Int32(todo.userId)
                        task.timestamp = Date()
                    }
                    saveData()
                    UserDefaults.standard.set(true, forKey: "didImportInitialTodos")
                }
            } catch {
                print("Failed to fetch todos from API: \(error)")
            }
        }
    }

    func fetchTodosFromAPI() async throws -> [Todo] {
        let url = URL(string: "https://dummyjson.com/todos")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(TodoResponse.self, from: data)
        return decoded.todos
    }
    
    var filteredTasks: [TaskEntity] {
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
            return savedTasks
        }
        return savedTasks.filter {
            $0.todo?.localizedCaseInsensitiveContains(searchText) == true
        }
    }
    
    func formatDateForDisplay(_ date: Date?) -> String {
        guard let date else { return "Date is empty" }
        return DateFormatter.userDateFormatter.string(from: date)
    }
    
    func taskWord(for count: Int) -> String {
        let rem100 = count % 100
        let rem10 = count % 10

        if rem100 >= 11 && rem100 <= 14 {
            return "задач"
        }

        switch rem10 {
        case 1:
            return "задача"
        case 2...4:
            return "задачи"
        default:
            return "задач"
        }
    }
}

