//
//  TaskStorage.swift
//  navigator
//
//  Created by Roberto Almeida on 12/06/22.
//

import Foundation
import CoreData
import Combine

class TaskStorage: NSObject, ObservableObject {
    var tasks = CurrentValueSubject<[TaskItem], Never>([])
    var userLocations = CurrentValueSubject<[UserLocation], Never>([])
    private let taskFetchController: NSFetchedResultsController<TaskItem>
    private let userLocationFetchController: NSFetchedResultsController<UserLocation>
    static let shared = TaskStorage()
    
    private override init() {
        let fetchRequest = TaskItem.fetchRequest()
        fetchRequest.sortDescriptors =  [NSSortDescriptor(key: "timestamp", ascending: true)]
        taskFetchController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: PersistenceController.shared.container.viewContext,
            sectionNameKeyPath: nil, cacheName: nil)
        
        let fetchUserLocationRequest = UserLocation.fetchRequest()
        fetchUserLocationRequest.sortDescriptors =  [NSSortDescriptor(key: "date", ascending: true)]
        userLocationFetchController = NSFetchedResultsController(
            fetchRequest: fetchUserLocationRequest,
            managedObjectContext: PersistenceController.shared.container.viewContext,
            sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        
        userLocationFetchController.fetchRequest.predicate = NSPredicate(format: "task.id = %@", "")

        userLocationFetchController.delegate = self

        
        let date = Date()
        let tomorrow = date.onlyDate!.addingTimeInterval(86400)
                
        taskFetchController.fetchRequest.predicate = NSPredicate(format: "timestamp > %@ && timestamp < %@", date.onlyDate! as NSDate, tomorrow as NSDate)
        
        //taskFetchController.delegate = self
        
        do {
            try taskFetchController.performFetch()
            tasks.value = taskFetchController.fetchedObjects ?? []
        } catch {
            NSLog("No se pudieron recuperar los objectos")
        }
    }
    
    func monitorTask(task: TaskItem) {
        print(task.id!)
        userLocationFetchController.fetchRequest.predicate = NSPredicate(format: "task.id =  %@", task.id!)
        do {
            try userLocationFetchController.performFetch()
            userLocations.value = userLocationFetchController.fetchedObjects ?? []
        } catch {
            NSLog("No se pudieron recuperar los objectos")
        }
    }

    func changeDate(date: Date) {
        let tomorrow = date.onlyDate!.addingTimeInterval(86400)
        taskFetchController.fetchRequest.predicate = NSPredicate(format: "timestamp > %@ && timestamp < %@", date.onlyDate! as NSDate, tomorrow as NSDate)
        do {
            try taskFetchController.performFetch()
            tasks.value = taskFetchController.fetchedObjects ?? []
        } catch {
            NSLog("No se pudieron recuperar los objectos")
        }
    }
    
    func startTask(task: TaskItem) {
        task.status = "ACTIVE"
        do {
            try PersistenceController.shared.container.viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        monitorTask(task: task)

    }
    
    func saveLocation(task: TaskItem, latitude: Double, longitude: Double, course: Double, speed: Double, date: Date) {
        let userLocation = UserLocation(context: PersistenceController.shared.container.viewContext)
        userLocation.id = UUID().uuidString
        userLocation.latitude = latitude
        userLocation.longitude = longitude
        userLocation.speed = speed
        userLocation.course = course
        userLocation.date = date
        userLocation.task = task
        do {
            try PersistenceController.shared.container.viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }

    }
    
    func addTask(id: String, status: String, address: String, type: String, notes: String) {
        let newItem = TaskItem(context: PersistenceController.shared.container.viewContext)
        newItem.timestamp = Date()
        newItem.id = id;
        newItem.address = address
        newItem.status = status
        newItem.type = type
        newItem.notes = notes
        do {
            try PersistenceController.shared.container.viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

}



extension TaskStorage: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        if let userLocations = controller.fetchedObjects as? [UserLocation] {
            self.userLocations.value = userLocations
        } else if let tasks = controller.fetchedObjects as? [TaskItem] {
            self.tasks.value = tasks
        }
        
    }
}

extension Date {

    var onlyDate: Date? {
        get {
            let calender = Calendar.current
            var dateComponents = calender.dateComponents([.year, .month, .day], from: self)
            dateComponents.timeZone = NSTimeZone.system
            return calender.date(from: dateComponents)
        }
    }

}
