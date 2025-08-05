# ToDo List
Простое iOS приложение для ведения списка дел с поддержкой Core Data.

## Возможности
- Отображение списка задач с названием, описанием, датой и статусом выполнения
- Добавление, редактирование и удаление задач
- Поиск по названию задач
- Отметка задачи как выполненной с мгновенным обновлением UI
- Импорт тестовых данных с DummyJSON API при первом запуске
- Сохранение всех данных в Core Data для работы оффлайн
- Контекстное меню для быстрого редактирования или удаления
- Детальный экран задачи

## Технологии
- Swift 5
- SwiftUI
- Core Data
- GCD
- MVVM

## Структура проекта
- Models (Todo.swift Core Data Model)
- ViewModels (TaskViewModel)
- Views (TaskListView, TaskView, AddTitleView, EditTitleView)
- Helpers (DateFormatter)
- ToDoTests
- ToDoUITests

## Требования
- Xcode 15+
- iOS 16+
- Swift 5.9+
- Интернет‑подключение при первом запуске
