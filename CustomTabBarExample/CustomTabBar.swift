//
//  CustomTabBar.swift
//  CustomTabBarExample
//
//  Created by Jędrzej Chołuj on 18/12/2021.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

final class CustomTabBar: UIStackView {
    
    var itemTapped: Observable<Int> { itemTappedSubject.asObservable() }
    var currentItem: Int = 0
    
    private lazy var customItemViews: [CustomItemView] = [profileItem, searchItem, favoriteItem]
    
    private let profileItem = CustomItemView(with: .profile, index: 0)
    private let searchItem = CustomItemView(with: .search, index: 1)
    private let favoriteItem = CustomItemView(with: .favorite, index: 2)
    
    private let itemTappedSubject = PublishSubject<Int>()
    private let disposeBag = DisposeBag()
    
    init() {
        super.init(frame: .zero)
        
        setupHierarchy()
        setupProperties()
        bind()
        
        setNeedsLayout()
        layoutIfNeeded()
        selectItem(index: 0)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupHierarchy() {
        addArrangedSubviews([profileItem, searchItem, favoriteItem])
    }
    
    func setupProperties() {
        distribution = .fillEqually
        alignment = .center
        
        backgroundColor = .systemIndigo
        setupCornerRadius(30)
        
        customItemViews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.clipsToBounds = true
        }
    }
    
    func selectItem(index: Int) {
        currentItem = index
        customItemViews.forEach { $0.isSelected = $0.index == index }
        itemTappedSubject.onNext(index)
    }
    
    //MARK: - Bindings
    
    func bind() {
        profileItem.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                self?.profileItem.animateClick {
                    self?.selectItem(index: 0)
                }
            }
            .disposed(by: disposeBag)
        
        searchItem.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                self?.searchItem.animateClick {
                    self?.selectItem(index: 1)
                }
            }
            .disposed(by: disposeBag)
        
        favoriteItem.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                self?.favoriteItem.animateClick {
                    self?.selectItem(index: 2)
                }
            }
            .disposed(by: disposeBag)
    }
}
