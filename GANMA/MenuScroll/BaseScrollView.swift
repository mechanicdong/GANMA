//
//  BaseScrollView.swift
//  GANMA
//
//  Created by 이동희 on 2022/04/20.
//

import Foundation
import UIKit

class BaseScrollView: UIScrollView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() { }
    func bind() { }
}

