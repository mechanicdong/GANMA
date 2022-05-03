//
//  Content.swift
//  GANMA
//
//  Created by 이동희 on 2022/05/01.
//

import UIKit

struct Content: Decodable {
    let sectionType: SectionType
    var contentItem: [Item]
    
    enum SectionType: String, Decodable {
        case main //only img
        case basic //img + description
        case recommend // 이력 기반 추천
        
        var identifier: String {
            switch self {
            case .main:
                return "ContentCollectionViewCell"
            case .basic:
                return "ContentCollectionViewBasicCell"
            case .recommend:
                return "ContentCollectionViewRecommendCell"
            }
        }
    }
}

struct Item: Decodable {
    let title: String
    let description: String
    let imageName: String
    let summary: [String]
    let publishedCount: [String]
    var didSelected: Bool
    
    var image: UIImage {
        return UIImage(named: imageName) ?? UIImage()
    }
}
