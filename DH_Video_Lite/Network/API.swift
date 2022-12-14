//
//  API.swift
//  DH_Video_Lite
//
//  Created by Aybike Zeynep Tiryaki on 17.11.2022.
//


import Moya

enum API {
    case newestVideo
}

extension API: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://api.donanimhaber.com/dev/and/api/videos?pageIndex=0&pageSize=15") else { fatalError() }
        return url
    }
    
    var path: String {
        switch self {
        case .newestVideo:
            return ""
        
        }
    }
    
    var method: Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .newestVideo:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
