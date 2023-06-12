//
//  TaskModelView.swift
//  navigator
//
//  Created by Roberto Almeida on 12/06/22.
//

import Foundation
import Combine
import CoreData

class TaskModelView: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var userLocations: [UserLocation] = []
    
    private let taskStorage = TaskStorage.shared;
    private let locationManager = LocationManager.shared
    
    private var cancellable: AnyCancellable?
    private var cancellable2: AnyCancellable?
    
    init(taskPublisher: AnyPublisher<[Task], Never> =
    TaskStorage.shared.tasks.eraseToAnyPublisher(),
         userLocationPublisher: AnyPublisher<[UserLocation], Never> =
         TaskStorage.shared.userLocations.eraseToAnyPublisher()) {
        cancellable = taskPublisher.sink { tasks in
            self.tasks = tasks
        }
        cancellable2 = userLocationPublisher.sink { userLocations in
            self.userLocations = userLocations
        }
    }

    public func addTask(id: String, status: String, address: String, type: String, notes: String) {
        taskStorage.addTask(id: id, status: status, address: address, type: type, notes: notes)
    }
    
    public func changeDate(date: Date) {
        taskStorage.changeDate(date: date)
    }
    
    func startTask(task: Task) {
        taskStorage.startTask(task: task)
        locationManager.startMonitoring(task: task)
    }
    
    func stopTask() {
        locationManager.stopMonitoring()
    }
    
    func resolveTask(task: Task) {
        
    }
    
    func getResolveActions(taskType: String) -> [Action] {
        if let url = Bundle.main.url(forResource: "actions", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                return try JSONDecoder().decode([Action].self, from: data)
            } catch {
                print("Error!! Unable to parse  .json")
            }
        }
        return []
    }
}

struct TaskModel: Identifiable {
    
    private var task: Task
    
    init(task: Task) {
        self.task = task
    }
    
    var id: NSManagedObjectID {
        task.objectID
    }
    
    var status: String {
        task.status ?? ""
    }
    var address: String {
        task.address ?? ""
    }
    var notes: String {
        task.notes ?? ""
    }
    var timestamp: Date {
        task.timestamp ?? Date()
    }
    var taskId: String {
        task.id ?? ""
    }

    
    
    
}
