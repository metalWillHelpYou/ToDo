//
//  ToDoUITests.swift
//  ToDoUITests
//
//  Created by metalWillHelpYou on 05.08.2025.
//

import XCTest

import XCTest

final class ToDoUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-UITestMode"] // опционально
        app.launch()
    }

    func testEmptyTaskListDisplaysCorrectly() throws {
        let taskCells = app.staticTexts.matching(identifier: "taskTitle_")
        XCTAssertEqual(taskCells.count, 0, "Список задач должен быть пуст")
    }

    func testNavigationTitleExists() {
        let title = app.navigationBars["Задачи"]
        XCTAssertTrue(title.exists, "Навигационный заголовок 'Задачи' должен отображаться")
    }
    func testAddButtonExists() {
        let addButton = app.buttons["addTaskButton"]
        XCTAssertTrue(addButton.exists, "Кнопка добавления задачи должна быть видна")
    }
    
    func testSearchBarExists() {
        let searchField = app.searchFields["Поиск"]
        XCTAssertTrue(searchField.exists, "Поле поиска должно быть отображено")
    }
    
    func testDeleteTaskFromContextMenu() {
        let taskText = "Go to the gym"

        let addButton = app.buttons["addTaskButton"]
        addButton.tap()

        let input = app.textFields["taskInputField"]
        XCTAssertTrue(input.waitForExistence(timeout: 2))
        input.tap()
        input.typeText(taskText)

        let returnKey = app.keyboards.buttons["return"]
        if returnKey.exists {
            returnKey.tap()
        }

        let allTaskRows = app.otherElements.matching(identifier: "taskRow_")
        let taskRow = allTaskRows.allElementsBoundByIndex.first { $0.staticTexts[taskText].exists }

        XCTAssertNotNil(taskRow, "Строка с задачей не найдена")
        taskRow?.press(forDuration: 1.0)

        let deleteButton = app.buttons["deleteTaskButton"]
        XCTAssertTrue(deleteButton.waitForExistence(timeout: 2))
        deleteButton.tap()

        XCTAssertFalse(app.staticTexts[taskText].waitForExistence(timeout: 2))
    }
    
    func testAddTitleViewIsPresented() {
        let addButton = app.buttons["addTaskButton"]
        XCTAssertTrue(addButton.exists, "Кнопка добавления задачи должна существовать")
        addButton.tap()

        let inputField = app.textFields["taskInputField"]
        XCTAssertTrue(inputField.waitForExistence(timeout: 2), "Поле ввода задачи из AddTitleView должно появиться")
    }
    
    func testAddTaskThroughAddTitleView() throws {
        let app = XCUIApplication()
        app.launch()

        let addButton = app.buttons["addTaskButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 2))
        addButton.tap()
        
        let inputField = app.textFields["taskInputField"]
        XCTAssertTrue(inputField.waitForExistence(timeout: 2))
        inputField.tap()
        inputField.typeText("Сходить в аптеку")

        let addButtonText = app.buttons["Добавить"]
        XCTAssertTrue(addButtonText.waitForExistence(timeout: 2))
        addButtonText.tap()

        let newTask = app.staticTexts.containing(NSPredicate(format: "label CONTAINS %@", "Сходить в аптеку")).firstMatch
        XCTAssertTrue(newTask.waitForExistence(timeout: 3), "Задача должна появиться в списке")
    }
}
