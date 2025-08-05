//
//  TaskViewModel.swift
//  ToDo
//
//  Created by metalWillHelpYou on 04.08.2025.
//

import Foundation
import CoreData

final class TaskViewModel: ObservableObject {
    let container: NSPersistentContainer
    private let backgroundContext: NSManagedObjectContext
    
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
        backgroundContext = container.newBackgroundContext()
        
        Task {
            await fetchTasks()
            await importFromAPIIfNeeded()
        }
    }
    
    func fetchTasks() async {
        do {
            try await backgroundContext.perform {
                let request = NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
                request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
                let results = try self.backgroundContext.fetch(request)

                Task { @MainActor in
                    self.savedTasks = results
                }
            }
        } catch {
            print("Error fetching: \(error)")
        }
    }

    func addTask(todo: String) async {
        guard !todo.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        await backgroundContext.perform {
            let newTask = TaskEntity(context: self.backgroundContext)
            newTask.todo = todo
            newTask.content = ""
            newTask.completed = false
            newTask.timestamp = Date()
            newTask.id = UUID().uuidString
            self.saveData()
        }
    }
    
    func edit(_ task: TaskEntity, newTodo: String) {
        guard !newTodo.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        task.todo = newTodo
        titleInput = ""
        objectWillChange.send()
        
        let context = container.newBackgroundContext()
        context.perform {
            do {
                if let objectInContext = try context.existingObject(with: task.objectID) as? TaskEntity {
                    objectInContext.todo = newTodo
                    try context.save()
                }
            } catch {
                print("Error saving edited todo: \(error)")
            }
        }
    }
    
    func delete(_ task: TaskEntity) async {
        await backgroundContext.perform {
            self.backgroundContext.delete(task)
            self.saveData()
        }
    }
    
    func saveContent(for task: TaskEntity, content: String) async {
        await backgroundContext.perform {
            task.content = content
            self.saveData()
        }
    }
    
    func toggleCompleteStatus(for task: TaskEntity) {
        task.completed.toggle()
        objectWillChange.send()
        
        let context = container.newBackgroundContext()
        context.perform {
            if let objectInContext = try? context.existingObject(with: task.objectID) as? TaskEntity {
                objectInContext.completed = task.completed
                do {
                    try context.save()
                } catch {
                    print("Error saving toggle status: \(error)")
                }
            }
        }
    }
    
    func saveData() {
        do {
            try backgroundContext.save()
            Task { await fetchTasks() }
        } catch {
            print("Save error: \(error)")
        }
    }
    
    func importFromAPIIfNeeded() async {
        let alreadyImported = UserDefaults.standard.bool(forKey: "didImportInitialTodos")
        guard !alreadyImported else { return }
        
        do {
            let todos = try await fetchTodosFromAPI()
            await backgroundContext.perform {
                for todo in todos {
                    let task = TaskEntity(context: self.backgroundContext)
                    task.id = UUID().uuidString
                    task.todo = todo.todo
                    task.completed = todo.completed
                    task.userId = Int32(todo.userId)
                    task.timestamp = Date()
                }
                self.saveData()
                UserDefaults.standard.set(true, forKey: "didImportInitialTodos")
            }
        } catch {
            print("Failed to fetch todos from API: \(error)")
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
        case 1: return "задача"
        case 2...4: return "задачи"
        default: return "задач"
        }
    }
}
