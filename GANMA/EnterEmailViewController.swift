//
//  EnterEmailViewController.swift
//  GANMA
//
//  Created by 이동희 on 2022/05/02.
//

import UIKit
import RxSwift

class EnterEmailViewController: UIViewController {
    let disposeBag = DisposeBag()
    var emailVC: [UIViewController] = []
    let emailSignUpVC = EmailSignUpViewController()
    let emailSignInVC = EmailSignInViewController()
    
    //TODO: Page Observer
    var currentPage: Int = 0 {
        didSet {
            bind(oldValue: oldValue, newValue: currentPage)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setNavigationBar()
        setupViewControllers()
        attribute()
        layout()
        setupDelegate()
        setViewControllersInPageVC()
    }
    
    func didTappedCell(at index: UISegmentedControl) {
        currentPage = index.selectedSegmentIndex
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        currentPage = 0
    }
    
    //TODO: buttonBar action - segmentControl 연동(observer)
    private func bind(oldValue: Int, newValue: Int) {
        //collectionview 선택
        let direction: UIPageViewController.NavigationDirection = oldValue < newValue ? .forward : .reverse
        pageVC.setViewControllers([emailVC[currentPage]], direction: direction, animated: true, completion: nil)
        
        //pageVC에서 페이징
        UIView.animate(withDuration: 0.3) {
            let originX = (self.segmentControl.frame.width / CGFloat(self.segmentControl.numberOfSegments)) * CGFloat(self.segmentControl.selectedSegmentIndex)
            self.buttonBar.frame.origin.x = originX
        }
        segmentControl.selectedSegmentIndex = newValue
    }
    
    private lazy var pageVC: UIPageViewController = {
        let pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        return pageVC
    }()
    
    private lazy var buttonBar: UIView = {
        let buttonBar = UIView()
        buttonBar.backgroundColor = .orange
        
        return buttonBar
    }()
    
    lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl()
        segmentControl.insertSegment(withTitle: "신규등록", at: 0, animated: true)
        segmentControl.insertSegment(withTitle: "로그인", at: 1, animated: true)
        
        return segmentControl
    }()
    
    private func setNavigationBar() {
        navigationItem.title = "이메일주소로 등록 및 로그인"
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func attribute() {
        view.addSubview(segmentControl)
        view.addSubview(buttonBar)
        addChild(pageVC)
        view.addSubview(pageVC.view)
        
        segmentControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        segmentControl.backgroundColor = .clear
        segmentControl.tintColor = .clear
        segmentControl.selectedSegmentIndex = 0
        segmentControl.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: "DINCondensed-Bold", size: 15) ?? UIFont(),
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
        ], for: .normal)
        segmentControl.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: "DINCondensed-Bold", size: 20) ?? UIFont(),
            NSAttributedString.Key.foregroundColor: UIColor.orange
        ], for: .selected)
        
    }
    
    private func layout() {
        segmentControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(5)
            $0.width.equalTo(view.snp.width)
            $0.height.equalTo(40)
        }
        buttonBar.snp.makeConstraints {
            $0.top.equalTo(segmentControl.snp.bottom)
            $0.height.equalTo(5)
            $0.leading.equalTo(segmentControl.snp.leading)
            $0.width.equalTo(segmentControl.snp.width).multipliedBy(1 / CGFloat(segmentControl.numberOfSegments))
        }
        pageVC.view.snp.makeConstraints {
            $0.top.equalTo(buttonBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        pageVC.didMove(toParent: self)
    }
    
    private func setupViewControllers() {
        [emailSignUpVC, emailSignInVC]
            .forEach {
                emailVC += [$0]
            }
    }
    
    private func setupDelegate() {
        pageVC.delegate = self
        pageVC.dataSource = self
    }
    
    private func setViewControllersInPageVC() {
        if let firstVC = emailVC.first {
            pageVC.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
//        UIView.animate(withDuration: 0.3) {
//            let originX = (self.segmentControl.frame.width / CGFloat(self.segmentControl.numberOfSegments)) * CGFloat(self.segmentControl.selectedSegmentIndex)
//            self.buttonBar.frame.origin.x = originX
//        }
        currentPage = segmentControl.selectedSegmentIndex
    }
}

extension EnterEmailViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = emailVC.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        if previousIndex < 0 {
            return nil
        }
        return emailVC[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = emailVC.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        if nextIndex == emailVC.count {
            return nil
        }
        return emailVC[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let currentVC = pageViewController.viewControllers?.first,
              let currentIndex = emailVC.firstIndex(of: currentVC) else { return }
        currentPage = currentIndex
    }
}


