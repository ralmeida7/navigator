import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    
    @ObservedObject var taskModelView = TaskModelView()
    let mapViewDelegate = MapViewDelegate()
    
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        print("Entra")
        print(taskModelView.userLocations.count)
        view.delegate = mapViewDelegate
        let coordinates = taskModelView.userLocations.map { (location) -> CLLocationCoordinate2D in
            CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }
        var count = 0;
        if ( coordinates.count > 0  ) {
            count = coordinates.count - 1
        }
        let line = MKPolyline(coordinates: coordinates, count: count)
        view.addOverlay(line)
        if (coordinates.count > 0) {
            view.centerCoordinate = coordinates.last!;
        }
        let annotations = taskModelView.tasks.map { (place) -> MKAnnotation in
            let annotation = MKPointAnnotation()
            annotation.title = place.type
            annotation.subtitle = place.description
            annotation.coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
            return annotation
        }
        if annotations.count != view.annotations.count {
            view.removeAnnotations(view.annotations)
            view.addAnnotations(annotations)
        }
    }
    
}

class MapViewDelegate: NSObject, MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.fillColor = UIColor.red.withAlphaComponent(0.5)
        renderer.strokeColor = UIColor.red.withAlphaComponent(0.8)
        return renderer
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
