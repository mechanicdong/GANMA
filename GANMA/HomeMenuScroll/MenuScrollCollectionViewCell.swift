//
//  MenuScrollCollectionViewCell.swift
//  GANMA
//
//  Created by 이동희 on 2022/04/21.
//

import Foundation
import UIKit
import RxSwift

class MenuScrollCollectionViewCell: UICollectionViewCell {
    var disposeBag = DisposeBag()
    var model: MenuScrollCollectionViewModel? { didSet { bind() } }
    
    static var id: String { NSStringFromClass(Self.self).components(separatedBy: ".").last ?? "" }
    
    lazy var contentsView: UIView = {
        let view = UIView()
        view.backgroundColor = .orange.withAlphaComponent(0.5) //default
        
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        
        return titleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
        configure()
    }
    
    override var isSelected: Bool {
        didSet {
            contentsView.backgroundColor = isSelected ? .orange : .orange.withAlphaComponent(0.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        addSubview(contentsView)
        contentsView.addSubview(titleLabel)
    }
    
    private func configure() {
        backgroundColor = .brown
        
        contentsView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func bind() {
        titleLabel.text = "\(model?.title ?? 0)"
    }
}
