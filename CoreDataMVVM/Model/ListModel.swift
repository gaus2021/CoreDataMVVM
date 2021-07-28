//
//  ListModel.swift
//  CoreDataMVVM
//
//  Created by Gaus on 28/07/21.
//

import Foundation

//MARK:- Header Title
enum HeaderTitle : String{
    case Today = "Today"
    case Tomorrow = "Tomorrow"
    case Upcoming = "Upcoming"
}

//MARK:- Error responses
struct dataResponse {
    let isSuccess : Bool
    let errorMsg: String
    let msg: String
}


enum ListDataEnums : String {
    case id = "id"
    case title = "title"
    case descriptions = "descriptions"
}

struct ListDataStruct {
    let id: String
    let title: String
    let descriptions: String
}
