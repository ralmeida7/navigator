//
//  TaskModelView.swift
//  navigator
//
//  Created by Roberto Almeida on 12/06/22.
//

import Foundation
import Combine
import CoreData
import Amplify

class TaskModelView: ObservableObject {
    @Published var tasks: [TaskItem] = []
    @Published var userLocations: [UserLocation] = []
    @Published var taskTypesActions: [String: [Action]] = [:]
    
    private let taskStorage = TaskStorage.shared;
    private let locationManager = LocationManager.shared
    
    private var cancellable: AnyCancellable?
    private var cancellable2: AnyCancellable?
    
    let baseUrl = "https://7qasxgtg0j.execute-api.us-west-2.amazonaws.com/"
    
    init(taskPublisher: AnyPublisher<[TaskItem], Never> =
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

    public func addTask(id: String, status: String, addressId: String, address: String, type: String, notes: String, date: String) {
        taskStorage.addTask(id: id, status: status, addressId: addressId, address: address, type: type, notes: notes, date: date)
    }
    
    public func changeDate(date: Date) {
        taskStorage.changeDate(date: date)
    }
    
    func startTask(task: TaskItem) {
        
        taskStorage.startTask(task: task)
        locationManager.startMonitoring(task: task)
    }
    
    func stopTask() {
        locationManager.stopMonitoring()
    }
    
    func resolveTask(task: TaskItem) {
        taskStorage.resolveTask(task: task)
    }
    
    func isActive() -> Bool {
        return locationManager.isActive()
    }
    
    func updateTask(task: String, status: String, taskData: String?) async throws -> Bool {
        let url = String(format: baseUrl + "tasks")
        guard let serviceUrl = URL(string: url) else { return false }
        var urlRequest = URLRequest(url: serviceUrl)
        urlRequest.httpMethod = "PUT"
        urlRequest.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        let formatter = DateFormatter()
        let date = Date()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date.addingTimeInterval(86400))
        //@todo utilizar usuario
        let updateTask = UpdateTask(user: "roberto", date: dateString, task: task, status: status, data: taskData)
        let httpBody = try JSONEncoder().encode(updateTask)
        urlRequest.httpBody = httpBody
        let (data, _) = try await URLSession.shared.data(from: serviceUrl)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        print(json)
        return true
    }
    
    func refresh() async throws {
        let user = try await Amplify.Auth.getCurrentUser()
        print(user.username)
        print(user.userId)
        let date = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.utc
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        //@todo utilizar usuario
        let url = String(format: "https://7qasxgtg0j.execute-api.us-west-2.amazonaws.com/users/roberto/tasks/\(dateString)")
        guard let serviceUrl = URL(string: url) else { return }
        let (data, _) = try await URLSession.shared.data(from: serviceUrl)
        let tasks = try JSONDecoder().decode([TaskDto].self, from: data)
        let localTasks = self.tasks.map { task in
            TaskDto(id: task.id ?? "", type: task.type ?? "", date: dateString, description: task.description, addressId: "", address: "", asigneeId: "", longitude: task.longitude, latitude: task.latitude, data: nil, status: task.status ?? "")
        }

        for task in tasks {
            if let actions = taskTypesActions[task.type] {
                print("Found task")
            } else {
                taskTypesActions[task.type] = try await getResolveActions(taskType: task.type)
            }
        }
        
        
        let difference = tasks.difference(from: localTasks) { t1, t2 in
            t1.id == t2.id
        }

        for task in tasks {
            print(task.date)
        }
        
        for change in difference {
            switch change {
            case let .remove(offset, _, _):
                taskStorage.deleteTask(task: self.tasks[offset])
            case let .insert(_, newElement, _):
                taskStorage.addTask(id: newElement.id, status: newElement.status, addressId: newElement.addressId ?? "", address: newElement.address!, type: newElement.type, notes: newElement.description, date: newElement.date)
            }
        }
    }
    
    func getResolveActions(taskType: String) async throws -> [Action] {
        let url = String(format: baseUrl + "catalogs/ASSIGNED_FORM/\(taskType)")
        guard let serviceUrl = URL(string: url) else { return [] }
        let (data, _) = try await URLSession.shared.data(from: serviceUrl)
        let actions = try JSONDecoder().decode([Action].self, from: data)
        return actions
    }
}

struct TaskModel: Identifiable {
    
    private var task: TaskItem
    
    init(task: TaskItem) {
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
