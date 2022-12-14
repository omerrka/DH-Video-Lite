//
//  DHVideoModel.swift
//  DH_Video_Lite
//
//  Created by Aybike Zeynep Tiryaki on 17.11.2022.
//

import Foundation


// MARK: - DHVideoModel
struct DHVideoModel: Codable {
    let hasError: Bool
    let message: String
    let unixTime: Int
    let server: String
    let data: DataClass
    let hashErrorCode: Int

    enum CodingKeys: String, CodingKey {
        case hasError = "HasError"
        case message = "Message"
        case unixTime = "UnixTime"
        case server = "Server"
        case data = "Data"
        case hashErrorCode = "HashErrorCode"
    }
}

// MARK: - DataClass
struct DataClass: Codable {
    let newest: Newest

    enum CodingKeys: String, CodingKey {
        case newest = "Newest"
    }
}

// MARK: - Newest
struct Newest: Codable {
    let name: String
    let dataa: [Datum]

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case dataa = "Data"
    }
}

// MARK: - Datum
struct Datum: Codable {
    let videos: [Video]
    let shortContent: String
    let duration: String
    let smallImage: NImage
    let title: String
    let createDateWellFormed: String
    let categoriUrl: String
    

    enum CodingKeys: String, CodingKey {

        case videos = "Videos"
        case shortContent = "ShortContent"
        case duration = "Duration"
        case smallImage = "SmallImage"
        case title = "Title"
        case createDateWellFormed = "CreateDateWellFormed"
        case categoriUrl = "CategoriUrl"

    }
}

// MARK: - NImage
struct NImage: Codable {
    let width, height: Int
    let value: String
    let colorAvarage: String

    enum CodingKeys: String, CodingKey {
        case width = "Width"
        case height = "Height"
        case value = "Value"
        case colorAvarage = "ColorAvarage"
        
    }
}

// MARK: - Video
struct Video: Codable {
    let value: String
    let size: Int

    enum CodingKeys: String, CodingKey {
        case value = "Value"
        case size = "Size"
    }
}
