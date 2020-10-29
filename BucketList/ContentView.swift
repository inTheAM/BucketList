//
//  ContentView.swift
//  BucketList
//
//  Created by Ahmed Mgua on 9/17/20.
//

import SwiftUI
import MapKit
import LocalAuthentication

struct ContentView: View {
	@State private var centerCoordinate	=	CLLocationCoordinate2D()
	@State private var selectedPlace:	MKPointAnnotation?
	@State private var showingPlaceDetails	=	false
	@State private var showingEditScreen	=	false
	
	@State private var locations	=	[CodableMKPointAnnotation]()
	
	let directory	=	FileManager().getDocumentsDirectory()
	
	func loadData()	{
		let filename	=	directory.appendingPathComponent("SavedPlaces")
		do	{
			let data	=	try	Data(contentsOf: filename)
			locations	=	try	JSONDecoder().decode([CodableMKPointAnnotation].self, from: data)
		}	catch	{
			print("Unable to load saved data.")
		}
	}
	
	func saveData()	{
		do	{
			let filename	=	directory.appendingPathComponent("SavedPlaces")
			let data	=	try	JSONEncoder().encode(self.locations)
			try	data.write(to: filename,	options: [.atomicWrite,	.completeFileProtection])
		}	catch	{
			print("Unable to save data.")
		}
	}
	
	@State private var isUnlocked	=	false
	
	func authenticate()	{
		let context	=	LAContext()
		var error:	NSError?
		
		if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)	{
			let reason	=	"TouchID to view saved places."
			context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)	{	success,	authenticationError	in
				DispatchQueue.main.async {
					if success	{
						self.isUnlocked	=	true
					}	else	{
//						error if there
					}
				}
			}
		}	else	{
//			no biometrics
		}
	}
	
	var	body: some View	{
		ZStack	{
			if isUnlocked	{
				MapView(annotations:	locations, centerCoordinate: $centerCoordinate,	selectedPlace: $selectedPlace,	showingPlaceDetails:	$showingPlaceDetails)
					.edgesIgnoringSafeArea(.all)
				Circle()
					.fill(Color.blue)
					.opacity(0.3)
					.frame(width:	32,	height:	32)
				VStack	{
					Spacer()
					HStack	{
						Spacer()
						Button(action:	{
							let newLocation	=	CodableMKPointAnnotation()
							newLocation.title	=	"Example location"
							newLocation.coordinate	=	self.centerCoordinate
							self.locations.append(newLocation)
							self.selectedPlace	=	newLocation
							self.showingEditScreen	=	true
						})	{
							Image(systemName: "plus")
								.font(.largeTitle)
							
						}.padding()
						.background(Color.black.opacity(0.75))
						.foregroundColor(.white)
						.clipShape(Circle())
						.padding(.trailing)
					}
				}
			}	else	{
				LinearGradient(gradient: Gradient(colors: isUnlocked	?	[Color.green, Color.blue]	:	[Color.red, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
					.edgesIgnoringSafeArea(.all)
					.blur(radius: 100)
				Button(action:	{
					self.authenticate()
				},	label:	{ZStack	{
					RoundedRectangle(cornerRadius: 25.0)
						.frame(width:	300,	height: 100)
						.foregroundColor(.white)
						.shadow(radius: 20)
					Text("Unlock to view saved places.")
				}})
			}
		}.onAppear(perform:	loadData)
		.alert(isPresented: $showingPlaceDetails){
			Alert(title: Text(selectedPlace?.title	??	"Unknown"), message: Text(selectedPlace?.subtitle	??	"Missing information"), primaryButton: .default(Text("OK")),	secondaryButton: .default(Text("Edit"))	{
				self.showingEditScreen	=	true
			})
		}
		.sheet(isPresented: $showingEditScreen,	onDismiss: saveData) {
			if selectedPlace	!=	nil	{
				EditPlaceDetailsView(placemark: self.selectedPlace!)
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
