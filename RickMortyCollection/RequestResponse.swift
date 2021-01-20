//
//  RequestResponse.swift
//  RickMortyCollection
//
//  Created by A4-iMAC01 on 19/01/2021.
//

import Foundation

class RequestResponse {
    struct CharacterListResponse:Decodable {
        let info:CharacterListResponseInfo
        var results:[CharacterListResponseResult]
    }
    struct  CharacterListResponseInfo:Decodable{
        let count:Int
        let pages:Int
        let next:String?
        let prev:String?
    }
    struct  CharacterListResponseResult:Decodable {
        let id:Int
        let name:String
        let status:String
        let species:String
        let type:String
        let gender:String
        let origin:InfoReference
        let location:InfoReference
        let image:String
        var imageData:Data?
        let episode:[String]
        let url:String
        let created:String
    }
    struct InfoReference:Decodable {
        let name:String
        let url:String?
    }
}
