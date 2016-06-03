//
//	LoginList.swift
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct LoginList{

	var descriptionField : String!
	var mobile : String!
	var name : String!
	var numOfPlace : Int!
	var shopEnd : String!
	var shopId : String!
	var shopOpen : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		descriptionField = dictionary["description"] as? String
		mobile = dictionary["mobile"] as? String
		name = dictionary["name"] as? String
		numOfPlace = dictionary["numOfPlace"] as? Int
		shopEnd = dictionary["shop_end"] as? String
		shopId = dictionary["shop_id"] as? String
		shopOpen = dictionary["shop_open"] as? String
	}

}