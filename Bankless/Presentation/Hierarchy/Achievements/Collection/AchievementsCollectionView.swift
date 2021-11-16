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
    
    let source = BehaviorRelay<ListSource>(value: .init())
    
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
            CollectionSectionHeaderCell.self,
            forCellWithReuseIdentifier: CollectionSectionHeaderCell.reuseIdentifier
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
        
        let source = Driver<ListSource>
            .combineLatest(
                titleOutput,
                attendanceTokensOutput,
                resultSelector: {
                    title,
                    attendanceTokens
                    -> ListSource in
                    
                    return ListSource(
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
            switch self.source.value.titleSection.rowPayload(at: row.index) {
                
            case .header:
                fatalError("not implemented")
            case let .content(viewModel):
                let titleCell = collectionView
                    .dequeueReusableCell(
                        withReuseIdentifier: AchievementsTitleCell.reuseIdentifier,
                        for: indexPath
                    ) as! AchievementsTitleCell
                titleCell.set(title: viewModel.title)
                cell = titleCell
            }
        case .attendanceTokens:
            switch self.source.value.attendanceTokensSection.rowPayload(at: row.index) {
                
            case let .header(viewModel):
                let attendanceTokensHeaderCell = collectionView
                    .dequeueReusableCell(
                        withReuseIdentifier: CollectionSectionHeaderCell.reuseIdentifier,
                        for: indexPath
                    ) as! CollectionSectionHeaderCell
                attendanceTokensHeaderCell.set(viewModel: viewModel)
                
                cell = attendanceTokensHeaderCell
            case let .content(viewModel):
                let attendanceTokenCell = collectionView
                    .dequeueReusableCell(
                        withReuseIdentifier: AttendanceTokenCell.reuseIdentifier,
                        for: indexPath
                    ) as! AttendanceTokenCell
                
                attendanceTokenCell.set(viewModel: viewModel)
                
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
            switch self.source.value.attendanceTokensSection.rowPayload(at: row.index) {
                
            case .header:
                return CGSize(width: width, height: Appearance.Text.Font.Title1.lineHeight * 2)
            case .content:
                return CGSize(width: itemDimension, height: itemDimension)
            }
        }
    }
}

extension AchievementCollectionView {
    class ListSource: BaseSectionedSource<ListSectionType>, SectionedSourceRequirements {
        typealias SectionType = ListSectionType
        typealias Row = SectionRow
        
        let titleSection: ListSource.Section<Void, AchievementsTitleViewModel>
        let attendanceTokensSection: ListSource.Section<
            SectionHeaderViewModel, AttendanceTokenViewModel
        >
        
        var numberOfRows: Int {
            return titleSection.numberOfRows
            + attendanceTokensSection.numberOfRows
        }
        
        init(
            title: String,
            attendanceTokensSectionTitle: String,
            attendanceTokenViewModels: [AttendanceTokenViewModel]
        ) {
            self.titleSection = .init(
                type: .title,
                viewModels: [
                    AchievementsTitleViewModel(title: title)
                ]
            )
            
            let headerVM = SectionHeaderViewModel()
            headerVM.set(title: attendanceTokensSectionTitle)
            
            self.attendanceTokensSection = .init(
                type: .attendanceTokens,
                headerViewModel: headerVM,
                viewModels: attendanceTokenViewModels
            )
        }
        
        override init() {
            self.titleSection = .init(
                type: .title,
                viewModels: []
            )
            
            self.attendanceTokensSection = .init(
                type: .attendanceTokens,
                viewModels: []
            )
        }
        
        func translateGlobalRow(at index: Int) -> SectionRow {
            guard index < numberOfRows else {
                fatalError("index is outside the bounds")
            }
            
            var localIndex = index
            
            if localIndex < titleSection.numberOfRows {
                return SectionRow(sectionType: .title, index: localIndex)
            }
            
            localIndex -= titleSection.numberOfRows
            if localIndex < attendanceTokensSection.numberOfRows {
                return SectionRow(sectionType: .attendanceTokens, index: localIndex)
            }
            
            fatalError("section not found")
        }
    }
    
    enum ListSectionType: SectionedSourceSectionType {
        case title
        case attendanceTokens
    }
}
