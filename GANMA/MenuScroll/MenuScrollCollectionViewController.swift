//
//  MenuScrollCollectionViewController.swift
//  GANMA
//
//  Created by 이동희 on 2022/04/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture


class MenuScrollCollectionViewController: UIViewController {
    var dataSource:  [MenuScrollCollectionViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDataSource()
        addSubViews()
        layout()
    }
    
    private func setupDataSource() {
        for i in 0..<10 {
            let model = MenuScrollCollectionViewModel(title: i)
            dataSource.append(model)
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 12
        flowLayout.scrollDirection = .horizontal
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    private func addSubViews() {
        view.addSubview(collectionView)
    }
    
    private func layout() {
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(96)
        }
    }
    
    private func setupDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func didtapCell(at indexPath: IndexPath) {
        //currentPage = indexPath.row
    }
}

extension MenuScrollCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuScrollCollectionViewCell.id, for: indexPath)
        
        if let cell = cell as? MenuScrollCollectionViewCell {
            cell.model = dataSource[indexPath.row]
            
            cell.contentsView.rx
                .tapGesture(configuration: .none)
                .when(.recognized)
                .asDriver { _ in .never() }
                .drive(onNext: { _ in
                    self.didtapCell(at: indexPath)
                })
                .disposed(by: cell.disposeBag)
        }
        
        return cell
    }
}

//수평스크롤이 되도록 height를 collecionView의 height와 동일하도록 설정
extension MenuScrollCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: collectionView.frame.height)
    }
}
