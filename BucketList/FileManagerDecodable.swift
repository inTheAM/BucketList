//
//  FileManagerDecodable.swift
//  BucketList
//
//  Created by Ahmed Mgua on 9/17/20.
//

import SwiftUI

extension	FileManager	{
	//	fetching doc directory
	func	getDocumentsDirectory()	->	URL	{
		let paths	=	FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return	paths[0]
	}
//	decoding
	func	decode<T:	Codable>(_	file:	String)	->	T	{
//		getting data from file
		guard	let	data	=	try?	Data(contentsOf: getDocumentsDirectory().appendingPathComponent(file))	else	{
			fatalError("Failed to load \(file) from bundle.")
		}
		guard let	output	=	try?	JSONDecoder().decode(T.self, from: data)	else	{
		fatalError("Failed to decode \(file) from disk.")
		}
//		returning type data
		return	output
	
	}
	
	
}
