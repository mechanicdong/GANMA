//
//  MenuScrollView.swift
//  GANMA
//
//  Created by 이동희 on 2022/04/20.
//

import Foundation
import UIKit

class MenuScrollView: BaseScrollView {
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 16.0
        view.backgroundColor = .separator

        return view
    }()
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//    }
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    var dataSource: [MenuDataModel]? {
        didSet { bind() }
    }
    
    override func configure() {
        super.configure()
        
        showsHorizontalScrollIndicator = false
        bounces = false
        
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
    }
    
    override func bind() {
        super.bind()
        
        dataSource?.forEach { data in
            let button = UIButton()
            button.setTitleColor(.black, for: .normal)
            button.setTitle(data.name, for: .normal)
            
            stackView.addArrangedSubview(button)
            button.snp.makeConstraints {
                $0.height.equalTo(42)
            }                                
        }
    }
}

