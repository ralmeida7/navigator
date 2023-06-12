//
//  ContentView.swift
//  navigator
//
//  Created by Roberto Almeida on 17/04/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @StateObject var taskViewModel = TaskModelView()
    @State var date = Date()
    @State var presentMap = false
    
    var body: some View {
        NavigationView {
            Section(content: {
                List(taskViewModel.tasks) { task in
                    NavigationLink(destination: TaskView(task: task)) {
                        VStack(alignment: .leading) {
                            HStack {
                                Label(task.type!, systemImage: "shippingbox")
                                Spacer()
                                Text(task.status!)
                            }
                            HStack {
                                Text(task.address!)
                                    .font(.headline)
                                    .fontWeight(.thin)
                                Spacer()
                                Text(task.timestamp!.formatted())
                            }
                        }
                    }
                }
            }, header: {
                VStack {
                    DatePicker(selection: $date, displayedComponents: .date, label: { Text("Fecha") })
                        .onChange(of: date) { date in
                            withAnimation {
                                taskViewModel.changeDate(date: date)
                            }                            
                        }
                    Text("Tareas Completadas")
                    ProgressView(value: 25, total: 100)
                }.padding()
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: toggle) {
                        Label("Add Item", systemImage: "map")
                    }
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .navigationBarTitle(Text("Tareas"))
            Text("Select an item")
        }
        .sheet(isPresented: $presentMap) {
            MapView()
        }
        
    }
    
    func toggle() {
        presentMap.toggle()
    }
    
    private func addItem() {
        withAnimation {
            taskViewModel.addTask(id: "1", status: "ASSIGNED", address: "San Cristobal", type: "DELIVERY", notes: "Nada")
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        //        withAnimation {
        //            offsets.map { items[$0] }.forEach(viewContext.delete)
        //
        //            do {
        //                try viewContext.save()
        //            } catch {
        //                // Replace this implementation with code to handle the error appropriately.
        //                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        //                let nsError = error as NSError
        //                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        //            }
        //        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
