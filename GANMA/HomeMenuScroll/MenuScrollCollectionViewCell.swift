//
//  MenuScrollCollectionViewCell.swift
//  GANMA
//
//  Created by 이동희 on 2022/04/21.
//
//TODO: 4/23 UISegmentControl 탭 이벤트 및 언더바 구현하기

import Foundation
import UIKit
import RxSwift

class MenuScrollCollectionViewCell: UICollectionViewCell {
    var disposeBag = DisposeBag()
    var model: MenuScrollCollectionViewModel? { didSet { bind() } }
    
    static var id: String { NSStringFromClass(Self.self).components(separatedBy: ".").last ?? "" }
    
    lazy var contentsView: UIView = {
        let view = UIView()
        //view.backgroundColor = .gray.withAlphaComponent(0.5) //default
        view.backgroundColor = .white.withAlphaComponent(0.5) //default
        
        return view
    }()
    
    lazy var buttonBar: UIView = {
        let buttonBar = UIView()
        
        buttonBar.translatesAutoresizingMaskIntoConstraints = false
        buttonBar.backgroundColor = .orange
        
        return buttonBar
    }()
    
    //TODO: Segment Control without Button
    var segment: UISegmentedControl = { //UIControl < UIView 상속
        let segment = UISegmentedControl()
        segment.selectedSegmentIndex = 0 //default
        segment.translatesAutoresizingMaskIntoConstraints = false
        
        return segment
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
        configure()
        isSegmentSelected()
        segment.insertSegment(withTitle: "\(model?.titles ?? "")", at: 0, animated: true)
    }
    
    private func isSegmentSelected() {
        segment.setTitleTextAttributes(
            [NSAttributedString.Key.font: UIFont(name: "DINCondensed-Bold", size: 15.0) ?? UIFont(),
             NSAttributedString.Key.foregroundColor: UIColor.black
            ],
            for: .normal
        )
        segment.setTitleTextAttributes(
            [NSAttributedString.Key.font: UIFont(name: "DINCondensed-Bold", size: 15.0) ?? UIFont(),
             NSAttributedString.Key.foregroundColor: UIColor.orange
            ],
            for: .selected
        )
    }
    
    override var isSelected: Bool {
        didSet {
            contentsView.backgroundColor = isSelected ? .white.withAlphaComponent(0.5) : .white
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        addSubview(contentsView)
        contentsView.addSubview(segment)
        contentsView.addSubview(buttonBar)
    }
    
    private func configure() {
        backgroundColor = .white
        
        contentsView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(5)
            $0.leading.trailing.equalToSuperview()
        }
        
        segment.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        buttonBar.snp.makeConstraints {
            $0.top.equalTo(segment.snp.bottom)
            $0.height.equalTo(4)
            $0.leading.equalTo(segment.snp.leading)
            $0.width.equalTo(segment.snp.width)
        }
    }
    
    private func bind() {
        segment.setTitle("\(model?.titles ?? "")", forSegmentAt: 0)
    }
}
