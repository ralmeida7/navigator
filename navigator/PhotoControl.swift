//
//  PhotoControl.swift
//  control-tower-app
//
//  Created by Roberto Almeida on 5/01/21.
//

import SwiftUI

struct PhotoControl: View {
    
    let label: String
    @Binding var imageName: String
    @Binding var image: UIImage?
    @State var showImagePicker = false
    
    var body: some View {
        HStack {
            Text(label)
            if let image = self.image {
                ZStack(alignment: .topTrailing) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()                        
                    Button(action: {
                        self.image = nil
                        showImagePicker = false
                    }) {
                        Image(systemName: "xmark.circle").tint(.red)
                    }
                }
            } else {
                Button(action: {
                    imageName = UUID().uuidString
                    showImagePicker = true
                }) {
                    Image(systemName: "camera.fill")
                }

            }
        }.sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $image)
        }
    }
}

//struct PhotoControl_Previews: PreviewProvider {
//    static var previews: some View {
//        PhotoControl()
//    }
//}
