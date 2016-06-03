//
//	LoginResult.swift
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct LoginResult{

	var currentHour : Int!
	var currentPage : Int!
	var list : LoginList!
	var msg : String!
	var pageSize : Int!
	var state : Int!
	var totalCount : Int!
	var totalPage : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		currentHour = dictionary["currentHour"] as? Int
		currentPage = dictionary["currentPage"] as? Int
		if let listData = dictionary["list"] as? NSDictionary{
				list = LoginList(fromDictionary: listData)
			}
		msg = dictionary["msg"] as? String
		pageSize = dictionary["pageSize"] as? Int
		state = dictionary["state"] as? Int
		totalCount = dictionary["totalCount"] as? Int
		totalPage = dictionary["totalPage"] as? Int
	}

}