//
//  MapView.swift
//  BucketList
//
//  Created by Ahmed Mgua on 9/17/20.

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
	
	var annotations:	[MKPointAnnotation]
	
	@Binding 	var centerCoordinate:	CLLocationCoordinate2D
	
	@Binding	var	selectedPlace:	MKPointAnnotation?
	@Binding	var	showingPlaceDetails:	Bool
	
	func makeUIView(context:	Context) ->  MKMapView	{
		let mapView	=	MKMapView()
		mapView.delegate	=	context.coordinator
		
		
		
		return mapView
	}
	
	func	updateUIView(_ view: MKMapView, context: Context) {
		if annotations.count	!=	view.annotations.count	{
			view.removeAnnotations(view.annotations)
			view.addAnnotations(annotations)
		}
	}
	
	class Coordinator:	NSObject,	MKMapViewDelegate	{
		var parent:	MapView
		
		init(_	parent:	MapView)	{
			self.parent	=	parent
		}
		
		func	mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
			parent.centerCoordinate	=	mapView.centerCoordinate
		}

		func	mapView(_	mapView:	MKMapView,	viewFor annotation:	MKAnnotation)	->	MKAnnotationView?	{
//			unique identifier for reuse
			let identifier	=	"Placemark"
//			try to find a cell to reuse
			var annotationView	=	mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
			
			if annotationView	==	nil	{
//				doesnt exist so we make a new one
				annotationView	=	MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//				allow pop up info
				annotationView?.canShowCallout	=	true
//				attach info button
				annotationView?.rightCalloutAccessoryView	=	UIButton(type: .detailDisclosure)
			}	else	{
//				we have a view to reuse
				annotationView?.annotation	=	annotation
			}
			
//			whether new or recycled, return view
			return annotationView
		}
		
		func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
			guard let placemark	=	view.annotation	as?	MKPointAnnotation	else	{	return	}
			
			parent.selectedPlace	=	placemark
			parent.showingPlaceDetails	=	true
		}
	}
	
	func	makeCoordinator() -> Coordinator {
		Coordinator(self)
	}
	
}

extension MKPointAnnotation	{
	static var nairobi:	MKPointAnnotation	{
		let annotation	=	MKPointAnnotation()
		annotation.title	=	"Nairobi"
		annotation.subtitle	=	"Capital city of Kenya"
		annotation.coordinate	=	CLLocationCoordinate2D(latitude: 1.292, longitude: 36.822)

		return annotation
	}
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
		MapView(annotations: [MKPointAnnotation.nairobi], centerCoordinate: .constant(MKPointAnnotation.nairobi.coordinate),	selectedPlace: .constant(MKPointAnnotation.nairobi),	showingPlaceDetails: .constant(false))
    }
}
