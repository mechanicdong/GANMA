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
        view.backgroundColor = .gray.withAlphaComponent(0.5) //default
        
        return view
    }()
    
    var button: UIButton = {
        let button = UIButton()
        
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
        configure()
    }
    
    override var isSelected: Bool {
        didSet {
            contentsView.backgroundColor = isSelected ? .white : .gray.withAlphaComponent(0.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        addSubview(contentsView)
        contentsView.addSubview(button)
    }
    
    private func configure() {
        backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .subheadline)
        button.setUnderline()
        //TODO: 버튼 탭 활성화하기(ScrollView & Button)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        
        contentsView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(5)
            $0.leading.trailing.equalToSuperview()
        }
        
        button.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func bind() {
        button.setTitle("\(model?.titles ?? "")", for: .normal)
    }
}

extension UIButton {
    func setUnderline() {
        guard let title = title(for: .normal) else { return }
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length: title.count)
        )
        setAttributedTitle(attributedString, for: .normal)
    }
}
