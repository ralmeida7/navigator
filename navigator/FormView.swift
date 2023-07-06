//
//  FormView.swift
//  navigator
//
//  Created by Roberto Almeida on 26/06/22.
//

import SwiftUI

struct FormView: View {
    
    @Binding var formControls: [FormControl]
    var task: TaskItem
    private let taskModelView = TaskModelView()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            Section {
                ForEach($formControls) { $formControl in
                    switch formControl.controlType {
                    case "Textfield" : TextField(formControl.label, text: $formControl.value)
                    case "Date" : DatePicker(formControl.label, selection: $formControl.dateValue, displayedComponents: [.date])
                    case "Photo" : PhotoControl(label: formControl.label, imageName: $formControl.value, image: $formControl.image)
                    default:
                        Text("Nada")
                    }
                }
            }
            Section {
                Button("Aceptar") {
                    taskModelView.resolveTask(task: task)
                    dismiss()
                }
            }
        }
    }
}




//struct FormView_Previews: PreviewProvider {
//    static var previews: some View {
//        FormView()
//    }
//}
