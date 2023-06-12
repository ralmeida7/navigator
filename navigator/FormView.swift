//
//  FormView.swift
//  navigator
//
//  Created by Roberto Almeida on 26/06/22.
//

import SwiftUI

struct FormView: View {
    
    @Binding var formControls: [FormControl]
    private let taskModelView = TaskModelView()
    
    
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
                    taskModelView.stopTask()
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
