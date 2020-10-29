//
//  MKPointAnnotation-ObservableObject.swift
//  BucketList
//
//  Created by Ahmed Mgua on 9/19/20.
//

import MapKit

extension	MKPointAnnotation:	ObservableObject	{
	public var wrappedTitle:	String	{
		get	{
			self.title	??	"Unknown place"
		}
		set	{
			title	=	newValue
		}
	}
	
	public var wrappedSubtitle:	String	{
		get	{
			self.subtitle	??	"Unknown"
		}
		
		set	{
			subtitle	=	newValue
		}
	}
}
