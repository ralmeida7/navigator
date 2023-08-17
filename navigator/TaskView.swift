//
//  TaskView.swift
//  navigator
//
//  Created by Roberto Almeida on 19/06/22.
//

import SwiftUI
import MapKit

struct TaskView: View {
    
    let taskModelView = TaskModelView()
    var task: TaskItem
    @State var region = MKCoordinateRegion()
//    @State var actions: Action? = nil
    @State var json = ""
    @State private var presentActions = false
    @State private var presentFormView = false
    @State var formControls: [FormControl] = []

    var body: some View {
        VStack(alignment: .leading) {
            Group {
                HStack {
                    Text("Tarea:")
                        .font(.headline)
                    Text(task.id!)
                        .font(.caption)
                }
                Divider()
                Text("Descripción")
                    .font(.headline)
                    .bold()
                Text(task.notes!)
                    .font(.caption)
                Divider()
            }
            Text("Dirección")
                .font(.headline)
                .bold()
            if let address = task.address {
                Text(address)
            }
            Divider()
            HStack {
                Text("Status:")
                    .font(.headline)
                    .bold()
                Spacer()
                Text(task.status!)
                    .font(.caption)
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            }
            HStack(alignment: .center) {
                Spacer()
                if task.status == "CREATED" {
                    Button("Iniciar") {
                        taskModelView.startTask(task: task)
                    }
                } else if task.status == "ACTIVE" {
                    Button("Resolver") {
                        taskModelView.stopTask()
                        presentActions = true
                    }
                }
                Spacer()
            }
            Map(coordinateRegion: $region,
                interactionModes: [],
                showsUserLocation: false,
                userTrackingMode: nil,
                annotationItems: [task]) { item in
                MapMarker(coordinate: CLLocationCoordinate2D(latitude: task.latitude, longitude: task.longitude))
            }
        }.padding(.all)
        .actionSheet(isPresented: $presentActions) {
            ActionSheet(title: Text("Finalización de tarea"), message: Text("Seleccione una opción"), buttons: getActions())
        }
        .sheet(isPresented: $presentFormView) {
            FormView(formControls: $formControls, task: task)
        }
    }
        
    func getActions()  -> [ActionSheet.Button] {
        let actions = taskModelView.taskTypesActions[task.type!]!
        var buttons =  actions.map { action in
            ActionSheet.Button.default(Text(action.name), action: {
                do {
                    self.json = action.json
                    self.formControls = try JSONDecoder().decode([FormControl].self, from: action.json.data(using: .utf8)!)
                } catch {
                    print(error)
                }
                presentFormView = true
            })
        }
        buttons.append(ActionSheet.Button.default(Text("Rechazar"), action: {
//            tasks.currentTask = "";
//            locationManager.stopMonitoring()
//            _ = trackerService.updateTask(task: task.id, status: "CANCELLED", code: nil, name: nil, taskData: nil, json: nil)
        }))
        buttons.append(ActionSheet.Button.cancel())
        return buttons;
    }
    
    
}
struct TaskView_Previews: PreviewProvider {
    
    
    
    static func createTask() -> TaskItem {
        let task = TaskItem(context: PersistenceController.preview.container.viewContext)
        task.timestamp = Date()
        task.id = "Tarea 1"
        task.address = "8a calle 7-60 Sector A10 Bosques de San Marino Residenciales Niza casa 15 San Cristobal Zona 8 de Mixco"
        task.notes = "Camino a Santa Barbara"
        task.type = "DELIVERY"
        task.status = "ASSIGNED"
        return task;
    }
    
    static var previews: some View {
        TaskView(task: createTask())
    }
}

