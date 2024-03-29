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
    var dataSourceVC: [UIViewController] = []
    let titles = ["TOP", "신작", "소년만화", "판타지", "일상", "이세계", "액션", "호러", "연애"]
    
    let homeVC = HomeViewController()
    //Page observer
    var currentPage: Int = 0 {
        didSet {
            bind(oldValue: oldValue, newValue: currentPage)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDataSource() // 1
        setupViewControllers()
        addSubViews()
        layout()
        setupDelegate()
        registerCell()
        setViewControllersInPageVC()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        currentPage = 0        
    }
    
    private func bind(oldValue: Int, newValue: Int) {
        //collectionView에서 선택한 경우
        let direction: UIPageViewController.NavigationDirection = oldValue < newValue ? .forward : .reverse
        pageViewController.setViewControllers([dataSourceVC[currentPage]], direction: direction, animated: true, completion: nil)
        
        //pageViewController에서 paging한 경우
        collectionView.selectItem(at: IndexPath(item: currentPage, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
    
    private func setupDataSource() {
        for i in 0..<titles.count {
            let model = MenuScrollCollectionViewModel(title: i, titles: titles[i])
            dataSource += [model]
        }
    }
    
    private func setupViewControllers() {
//        var i = 0
        dataSource.forEach { _ in
            //let vc = UIViewController()
            let vc = TopPagingViewController()
//            let red = CGFloat(arc4random_uniform(256)) / 255
//            let green = CGFloat(arc4random_uniform(256)) / 255
//            let blue = CGFloat(arc4random_uniform(256)) / 255
            
//            vc.view.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
//
//            let label = UILabel()
//            label.text = "\(i)"
//            label.font = .systemFont(ofSize: 15, weight: .bold)
//            i += 1
//
//            vc.view.addSubview(label)
//            label.snp.makeConstraints {
//                $0.center.equalToSuperview()
//            }
            dataSourceVC += [vc]
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 12
        flowLayout.scrollDirection = .horizontal
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.backgroundColor = .white
        
        return view
    }()
    
    lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        return vc
    }()

    private func addSubViews() {
        view.addSubview(collectionView)
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
    }
    
    private func layout() {
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(48)
        }
        
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        pageViewController.didMove(toParent: self)
    }
    
    private func setupDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
    }
    
    private func registerCell() {
        collectionView.register(MenuScrollCollectionViewCell.self, forCellWithReuseIdentifier: MenuScrollCollectionViewCell.id)
    }
    
    private func setViewControllersInPageVC() {
        if let firstVC = dataSourceVC.first {
            pageViewController.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func didTapCell(at indexPath: IndexPath) {
        currentPage = indexPath.item
    }
}

extension MenuScrollCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuScrollCollectionViewCell.id, for: indexPath)
        
        if let cell = cell as? MenuScrollCollectionViewCell {
            cell.model = dataSource[indexPath.item]
            
            cell.contentsView.rx.tapGesture(configuration: .none)
                .when(.recognized)
                .asDriver { _ in .never() }
                .drive(onNext: { [weak self] _ in
                    self?.didTapCell(at: indexPath)
                })
                .disposed(by: cell.disposeBag)
            
            cell.segment.rx.tapGesture(configuration: .none)
                .when(.recognized)
                .asDriver { _ in .never() }
                .drive(onNext: { [weak self] _ in
                    self?.didTapCell(at: indexPath)
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

extension MenuScrollCollectionViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = dataSourceVC.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        if previousIndex < 0 {
            return nil
        }
        return dataSourceVC[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = dataSourceVC.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        if nextIndex == dataSourceVC.count {
            return nil
        }
        return dataSourceVC[nextIndex]
    }
    
    //pageViewController 애니메이션이 끝난 경우 호출되는 UICollectionViewDeleagteFlowLayout 델리게이트
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let currentVC = pageViewController.viewControllers?.first,
              let currentIndex = dataSourceVC.firstIndex(of: currentVC) else { return }
        currentPage = currentIndex
    }
}
