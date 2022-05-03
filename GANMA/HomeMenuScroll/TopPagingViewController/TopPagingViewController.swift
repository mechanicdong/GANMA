//
//  TopPagingViewController.swift
//  GANMA
//
//  Created by 이동희 on 2022/04/30.
//TODO: entity 설정 및 크기 다른 이미지 표현을 위해 collectionview 사용

import Foundation
import UIKit

class TopPagingViewController: UIViewController {
    var contents: [Content] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contents = getContents()
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = layout()
    }
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionview = UICollectionView(frame: .init(x: 0, y: 0, width: 500, height: 500), collectionViewLayout: flowLayout)
        collectionview.register(ContentCollectionViewCell.self, forCellWithReuseIdentifier: "ContentCollectionViewCell")
        collectionview.register(ContentCollectionViewBasicCell.self, forCellWithReuseIdentifier: "ContentCollectionViewBasicCell")
        
        return collectionview
    }()
    
    func layout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionNumber, environment -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            
            switch self.contents[sectionNumber].sectionType {
            case .main:
                return self.createMainTypeSection()
            case .basic:
                return self.createBasicTypeSection()
            case .recommend:
                return self.createMainTypeSection()
            }
            
        }
    }
    
    // 메인 section layout 설정
    private func createMainTypeSection() -> NSCollectionLayoutSection {
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(0.75))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 10, leading: 5, bottom: 0, trailing: 5)
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        //secion
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
        return section
    }
    
    private func createBasicTypeSection() -> NSCollectionLayoutSection {
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(0.75))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        //secion
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        section.contentInsets = .init(top: 5, leading: 5, bottom: 0, trailing: 5)
        return section
    }
    
    func getContents() -> [Content] {
        guard let path = Bundle.main.path(forResource: "Content", ofType: "plist"),
              let data = FileManager.default.contents(atPath: path),
              let list = try? PropertyListDecoder().decode([Content].self, from: data) else { return [] }
        return list
    }
}

extension TopPagingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case -1: // not use
            return 1
        default:
            return contents[section].contentItem.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch contents[indexPath.section].sectionType {
        case .main:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCollectionViewCell", for: indexPath) as? ContentCollectionViewCell else  { return UICollectionViewCell() }
            cell.imageView.image = contents[indexPath.section].contentItem[indexPath.row].image
            return cell
            
        case .basic:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCollectionViewBasicCell", for: indexPath) as? ContentCollectionViewBasicCell else { return UICollectionViewCell() }
            cell.imageView.image = contents[indexPath.section].contentItem[indexPath.row].image
            cell.titleLabel.text = contents[indexPath.section].contentItem[indexPath.row].title
            cell.descriptionLabel.text = contents[indexPath.section].contentItem[indexPath.row].description
            //cell.summaryLabel.text = contents[indexPath.section].contentItem[indexPath.row].summary[indexPath.row]
            
            cell.layer.cornerRadius = 3
            cell.layer.shadowOffset = CGSize(width: 20, height: 0)
            cell.layer.shadowRadius = 15
            cell.contentView.layer.masksToBounds = true
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOpacity = 0.4
            
            return cell
            
        case .recommend:
            return UICollectionViewCell()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return contents.count
    }
}

extension TopPagingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        contents[indexPath.section].contentItem[indexPath.row].didSelected = true
        print(contents[indexPath.section].contentItem[indexPath.row])
    }
}
