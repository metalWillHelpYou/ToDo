//
//  ToDoTests.swift
//  ToDoTests
//
//  Created by metalWillHelpYou on 05.08.2025.
//

import XCTest
@testable import ToDo

final class TaskViewModel_LogicTests: XCTestCase {
    var sut: TaskViewModel!

    override func setUp() {
        super.setUp()
        sut = TaskViewModel()
        
        sut.savedTasks = []
        sut.searchText = ""
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testFilteredTasks_withEmptySearchText_returnsAllSavedTasks() {
        let task1 = TaskEntity(context: sut.container.viewContext)
        task1.todo = "Buy milk"
        let task2 = TaskEntity(context: sut.container.viewContext)
        task2.todo = "Call mom"
        sut.savedTasks = [task1, task2]
        sut.searchText = ""

        let filtered = sut.filteredTasks
        XCTAssertEqual(filtered.count, 2)
    }

    func testFilteredTasks_withSearchText_filtersTasks() {
        let task1 = TaskEntity(context: sut.container.viewContext)
        task1.todo = "Buy milk"
        let task2 = TaskEntity(context: sut.container.viewContext)
        task2.todo = "Call mom"
        sut.savedTasks = [task1, task2]

        sut.searchText = "buy"
        let filtered = sut.filteredTasks
        XCTAssertEqual(filtered.count, 1)
        XCTAssertEqual(filtered.first?.todo, "Buy milk")
    }

    func testFilteredTasks_withSearchText_noMatches_returnsEmpty() {
        let task1 = TaskEntity(context: sut.container.viewContext)
        task1.todo = "Buy milk"
        sut.savedTasks = [task1]

        sut.searchText = "walk"
        let filtered = sut.filteredTasks
        XCTAssertTrue(filtered.isEmpty)
    }

    func testFormatDateForDisplay_withNil_returnsPlaceholder() {
        let formatted = sut.formatDateForDisplay(nil)
        XCTAssertEqual(formatted, "Date is empty")
    }

    func testFormatDateForDisplay_withValidDate_formatsCorrectly() {
        let date = Date(timeIntervalSince1970: 0) // 01.01.1970 UTC
        let formatted = sut.formatDateForDisplay(date)

        let expected = DateFormatter.userDateFormatter.string(from: date)
        XCTAssertEqual(formatted, expected)
    }

    func testTaskWord_returnsCorrectWordForm() {
        XCTAssertEqual(sut.taskWord(for: 1), "задача")
        XCTAssertEqual(sut.taskWord(for: 2), "задачи")
        XCTAssertEqual(sut.taskWord(for: 4), "задачи")
        XCTAssertEqual(sut.taskWord(for: 5), "задач")
        XCTAssertEqual(sut.taskWord(for: 11), "задач")
        XCTAssertEqual(sut.taskWord(for: 22), "задачи")
        XCTAssertEqual(sut.taskWord(for: 14), "задач")
        XCTAssertEqual(sut.taskWord(for: 101), "задача")
    }
}
