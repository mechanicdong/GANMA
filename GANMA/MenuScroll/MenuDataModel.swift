//
//  MenuDataModel.swift
//  GANMA
//
//  Created by 이동희 on 2022/04/20.
//

import Foundation

struct MenuDataModel {
    enum MenuType: String {
        case TOP
        case 신간
        case 이력
        case 소년만화
        case 일상
        case 판타지
        case 이세계
        case 호러
    }
    
    let type: MenuType
    
    var name: String {
        return type.rawValue
    }
}

struct Mocks {
    static func getDataSource() -> [MenuDataModel] {
        return [MenuDataModel(type: .TOP),
                MenuDataModel(type: .신간),
                MenuDataModel(type: .이력),
                MenuDataModel(type: .소년만화),
                MenuDataModel(type: .일상),
                MenuDataModel(type: .판타지),
                MenuDataModel(type: .이세계),
                MenuDataModel(type: .호러)
        ]
    }
}
