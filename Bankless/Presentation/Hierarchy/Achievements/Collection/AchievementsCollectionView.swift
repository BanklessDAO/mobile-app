//
//  Created with ♥ by BanklessDAO contributors on 2021-10-17.
//  Copyright (C) 2021 BanklessDAO.

//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Affero General Public License as
//  published by the Free Software Foundation, either version 3 of the
//  License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Affero General Public License for more details.
//
//  You should have received a copy of the GNU Affero General Public License
//  along with this program.  If not, see https://www.gnu.org/licenses/.
//
    

import Foundation
import UIKit
import Cartography
import RxSwift
import RxCocoa

final class AchievementCollectionView: BaseView<AchievementCollectionViewModel>,
                                       UICollectionViewDataSource,
                                       UICollectionViewDelegate,
                                       UICollectionViewDelegateFlowLayout
{
    // MARK: - Properties -
    
    var flowLayout: UICollectionViewFlowLayout!
    let refreshTrigger = PublishRelay<Void>()
    
    // MARK: - Subviews -
    
    private(set) var collectionView: UICollectionView!
    
    // MARK: - Source -
    
    let source = BehaviorRelay<CollectionSource>(value: .init())
    
    // MARK: - Initializers -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup -
    
    private func setUp() {
        setUpSubviews()
        setUpConstraints()
    }
    
    func setUpSubviews() {
        setUpCollection()
    }
    
    private func setUpCollection() {
        backgroundColor = .backgroundBlack
        
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = contentPaddings.left
        flowLayout.minimumLineSpacing = contentPaddings.top
        flowLayout.sectionInset = contentInsets
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .backgroundBlack
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(
            AchievementsTitleCell.self,
            forCellWithReuseIdentifier: AchievementsTitleCell.reuseIdentifier
        )
        
        collectionView.register(
            AchievementsSectionHeaderCell.self,
            forCellWithReuseIdentifier: AchievementsSectionHeaderCell.reuseIdentifier
        )
        
        collectionView.register(
            AttendanceTokenCell.self,
            forCellWithReuseIdentifier: AttendanceTokenCell.reuseIdentifier
        )
        
        addSubview(collectionView)
    }
    
    func setUpConstraints() {
        constrain(collectionView, self) { (collection, view) in
            collection.edges == view.safeAreaLayoutGuide.edges
        }
    }
    
    override func bindViewModel() {
        let output = viewModel.transform(input: input())
        
        let titleOutput = output.title
        
        let attendanceTokensOutput = Driver.combineLatest(
            output.attendanceTokensSectionTitle,
            output.attendanceTokenViewModels
        )
        
        let source = Driver<CollectionSource>
            .combineLatest(
                titleOutput,
                attendanceTokensOutput,
                resultSelector: {
                    title,
                    attendanceTokens
                    -> CollectionSource in
                    
                    return CollectionSource(
                        title: title,
                        attendanceTokensSectionTitle: attendanceTokens.0,
                        attendanceTokenViewModels: attendanceTokens.1
                    )
                })
        
        source.drive(self.source).disposed(by: disposer)
        
        self.source
            .subscribe(onNext: { [weak self] _ in self?.collectionView.reloadData() })
            .disposed(by: disposer)
    }
    
    private func input() -> AchievementCollectionViewModel.Input {
        return AchievementCollectionViewModel.Input(
            refresh: refreshTrigger.asDriver(onErrorDriveWith: .empty()),
            selection: collectionView.rx.itemSelected.asDriver()
        )
    }
    
    // MARK: - Data source -
    
    func collectionView(
        _ collectionView: UICollectionView, numberOfItemsInSection section: Int
    ) -> Int {
        return self.source.value.numberOfRows
    }
    
    func collectionView(
        _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: UICollectionViewCell
        
        let row = self.source.value.translateGlobalRow(at: indexPath.row)
        
        switch row.sectionType {
            
        case .title:
            switch self.source.value.titleSection.rowType(at: row.localIndex) {
                
            case .header:
                fatalError("not implemented")
            case .content:
                let titleCell = collectionView
                    .dequeueReusableCell(
                        withReuseIdentifier: AchievementsTitleCell.reuseIdentifier,
                        for: indexPath
                    ) as! AchievementsTitleCell
                titleCell.set(title: self.source.value.title)
                cell = titleCell
            }
        case .attendanceTokens:
            switch self.source.value.attendanceTokensSection.rowType(at: row.localIndex) {
                
            case .header:
                let attendanceTokensHeaderCell = collectionView
                    .dequeueReusableCell(
                        withReuseIdentifier: AchievementsSectionHeaderCell.reuseIdentifier,
                        for: indexPath
                    ) as! AchievementsSectionHeaderCell
                attendanceTokensHeaderCell
                    .set(title: self.source.value.attendanceTokensSection.title ?? "")
                
                cell = attendanceTokensHeaderCell
            case .content:
                let attendanceTokenViewModel = self.source.value
                    .attendanceTokensSection
                    .viewModels[
                        row.localIndex
                        - (self.source.value.attendanceTokensSection.hasHeader ? 1 : 0)
                    ]
                
                let attendanceTokenCell = collectionView
                    .dequeueReusableCell(
                        withReuseIdentifier: AttendanceTokenCell.reuseIdentifier,
                        for: indexPath
                    ) as! AttendanceTokenCell
                
                attendanceTokenCell.set(viewModel: attendanceTokenViewModel)
                
                cell = attendanceTokenCell
            }
        }
        
        return cell
    }
    
    // MARK: - Flow layout -
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.bounds.width
        let numberOfItemsPerRow: CGFloat = 3
        let spacing: CGFloat = flowLayout.minimumInteritemSpacing
        let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
        let itemDimension = floor(availableWidth / numberOfItemsPerRow)
        
        let row = self.source.value.translateGlobalRow(at: indexPath.row)
        switch row.sectionType {
            
        case .title:
            return CGSize(width: width, height: Appearance.Text.Font.Header1.lineHeight * 2)
        case .attendanceTokens:
            switch self.source.value.attendanceTokensSection.rowType(at: row.localIndex) {
                
            case .header:
                return CGSize(width: width, height: Appearance.Text.Font.Title1.lineHeight * 2)
            case .content:
                return CGSize(width: itemDimension, height: itemDimension)
            }
        }
    }
}

extension AchievementCollectionView {
    struct CollectionSource {
        let title: String
        let titleSection: Section<AchievementsTitleViewModel>
        let attendanceTokensSection: Section<AttendanceTokenViewModel>
        
        var numberOfRows: Int {
            return titleSection.numberOfRows
                + attendanceTokensSection.numberOfRows
        }
        
        init(
            title: String,
            attendanceTokensSectionTitle: String,
            attendanceTokenViewModels: [AttendanceTokenViewModel]
        ) {
            self.title = title
            
            self.titleSection = .init(
                type: .title,
                viewModels: [
                    AchievementsTitleViewModel()
                ]
            )
            
            self.attendanceTokensSection = .init(
                type: .attendanceTokens,
                title: attendanceTokensSectionTitle,
                isExpandable: false,
                viewModels: attendanceTokenViewModels
            )
        }
        
        init() {
            self.title = ""
            
            self.titleSection = .init(
                type: .title,
                title: "",
                isExpandable: false,
                viewModels: []
            )
            
            self.attendanceTokensSection = .init(
                type: .attendanceTokens,
                title: "",
                isExpandable: true,
                viewModels: []
            )
        }
        
        func translateGlobalRow(at index: Int) -> (sectionType: SectionType, localIndex: Int) {
            guard index < numberOfRows else {
                fatalError("index is outside the bounds")
            }
            
            var localIndex = index
            
            if localIndex < titleSection.numberOfRows {
                return (sectionType: .title, localIndex: localIndex)
            }
            
            localIndex -= titleSection.numberOfRows
            if localIndex < attendanceTokensSection.numberOfRows {
                return (sectionType: .attendanceTokens, localIndex: localIndex)
            }
            
            fatalError("section not found")
        }
    }
}

extension AchievementCollectionView.CollectionSource {
    enum SectionType {
        case title
        case attendanceTokens
    }
    
    struct Section<T> {
        let type: SectionType
        let title: String?
        let hasHeader: Bool
        let isExpandable: Bool
        let viewModels: [T]
        
        var isEmpty: Bool {
            return viewModels.isEmpty
        }
        
        var numberOfRows: Int {
            guard !isEmpty else { return 0 }
            return (hasHeader ? 1 : 0)
            + viewModels.count
        }
        
        init(
            type: SectionType,
            viewModels: [T]
        ) {
            self.type = type
            self.title = nil
            self.hasHeader = false
            self.isExpandable = false
            self.viewModels = viewModels
        }
        
        init(
            type: SectionType,
            title: String,
            isExpandable: Bool,
            viewModels: [T]
        ) {
            self.type = type
            self.title = title
            self.hasHeader = true
            self.isExpandable = isExpandable
            self.viewModels = viewModels
        }
        
        func rowType(at index: Int) -> Row.`Type` {
            if hasHeader && index == 0 {
                return .header
            }
            
            guard index < numberOfRows else {
                fatalError("index is outside the bounds")
            }
            
            return .content
        }
    }
}

extension AchievementCollectionView.CollectionSource.Section {
    enum Row {
        enum `Type` {
            case header
            case content
        }
    }
}
