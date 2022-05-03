//
//  ContentCollectionViewBasicCell.swift
//  GANMA
//
//  Created by 이동희 on 2022/05/01.
//

import Foundation
import UIKit
//영화평점앱 - 5강 - 12분10초 컬렉션뷰 참고할 것
class ContentCollectionViewBasicCell: UICollectionViewCell {
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let summaryLabel = UILabel()
    
    let contentStackView = UIStackView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(imageView)
        addSubview(contentStackView)
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
        
        contentStackView.axis = .vertical
        contentStackView.alignment = .center
        contentStackView.distribution = .equalSpacing
        
        [titleLabel, descriptionLabel, summaryLabel]
            .forEach {
            contentStackView.addArrangedSubview($0)
            }
        
        imageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        contentStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.top.equalTo(imageView.snp.bottom)
        }
        
        imageView.contentMode = .scaleAspectFit
                
        titleLabel.font = .systemFont(ofSize: 10, weight: .bold)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .black
        titleLabel.sizeToFit()
        
        descriptionLabel.font = .systemFont(ofSize: 8, weight: .semibold)
        titleLabel.numberOfLines = 2
        descriptionLabel.textColor = .black
        descriptionLabel.sizeToFit()
        
        summaryLabel.font = .systemFont(ofSize: 7, weight: .semibold)
        summaryLabel.textColor = .black
        summaryLabel.sizeToFit()
    }
}
