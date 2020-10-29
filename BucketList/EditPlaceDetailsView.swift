//
//  EditPlaceDetailsView.swift
//  BucketList
//
//  Created by Ahmed Mgua on 9/19/20.
//

import SwiftUI
import MapKit

struct EditPlaceDetailsView: View {
	@Environment(\.presentationMode)	var presentationMode
	@ObservedObject var placemark:	MKPointAnnotation
	
	@State private var loadingState	=	LoadingState.loading
	@State private var pages	=	[Page]()
	
	func fetchNearbyAttractions()	{
		let urlString	=	"https://en.wikipedia.org/w/api.php?ggscoord=\(placemark.coordinate.latitude)%7C\(placemark.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
		
		guard let url	=	URL(string: urlString)	else	{
			print("Incorrect URL")
			return
		}
		
		URLSession.shared.dataTask(with: url)	{	data,	response,	error	in
			if let data	=	data	{
				if let items	=	try?	JSONDecoder().decode(Result.self, from: data)	{
					self.pages	=	Array(items.query.pages.values).sorted()
					self.loadingState	=	.loaded
					return
				}
			}
			self.loadingState	=	.failed
		}.resume()
	}
	
    var body: some View {
		NavigationView	{
			
			Form	{
				Section	{
					TextField("Place name",	text:	$placemark.wrappedTitle)
					TextField("Description",	text:	$placemark.wrappedSubtitle)
				}
				
				Section(header: Text("Nearby attractions"))	{
					if loadingState	==	.loaded	{
						List(pages, id: \.pageid)	{ page in
							Text(page.title).font(.headline)	+	Text(":")	+	Text(page.description).italic()
						}
					}	else if loadingState	==	.loading	{
						Text("Loading...")
					}	else	{
						Text("Please try again")
					}
				}
			}.navigationTitle("Edit place details")
			.navigationBarItems(trailing: Button("Done")	{
				self.presentationMode.wrappedValue.dismiss()
			})
			.onAppear(perform:	fetchNearbyAttractions)
			
			
		}
    }
	
	enum LoadingState {
		case loading,	loaded,	failed
	}
}

struct EditPlaceDetailsView_Previews: PreviewProvider {
    static var previews: some View {
		EditPlaceDetailsView(placemark: MKPointAnnotation.nairobi)
    }
}
