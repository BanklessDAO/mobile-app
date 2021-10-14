//
//  Created with ♥ by BanklessDAO contributors on 2021-09-30.
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

final class HomeTimelineView: BaseView<HomeTimelineViewModel>,
                              UITableViewDataSource,
                              UITableViewDelegate
{
    // MARK: - Properties -
    
    let refreshTrigger = PublishRelay<Void>()
    private let sectionExpandButtonRelay = PublishRelay<Int>()
    
    // MARK: - Subviews -
    
    private(set) var tableView: UITableView!
    
    // MARK: - Source -
    
    let source = BehaviorRelay<TableSource>(value: .init())
    
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
        setUpTable()
    }
    
    private func setUpTable() {
        backgroundColor = .backgroundBlack
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .backgroundBlack
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.contentInsetAdjustmentBehavior = .never
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(
            FeaturedNewsCell.self,
            forCellReuseIdentifier: FeaturedNewsCell.reuseIdentifier
        )
        
        tableView.register(
            TimelineSectionHeaderCell.self,
            forCellReuseIdentifier: TimelineSectionHeaderCell.reuseIdentifier
        )
        
        tableView.register(
            BountyListCell.self,
            forCellReuseIdentifier: BountyListCell.reuseIdentifier
        )
        
        tableView.register(
            AcademyCourseListCell.self,
            forCellReuseIdentifier: AcademyCourseListCell.reuseIdentifier
        )
        
        addSubview(tableView)
    }
    
    func setUpConstraints() {
        constrain(tableView, self) { (table, view) in
            table.edges == view.safeAreaLayoutGuide.edges
        }
    }
    
    override func bindViewModel() {
        let output = viewModel.transform(input: input())
        
        let generalOutput = Driver.combineLatest(
            output.title,
            output.expandSectionButtonTitle
        )
        
        let bountiesOutput = Driver.combineLatest(
            output.bountiesSectionTitle,
            output.bountyViewModels
        )
        
        let academyOutput = Driver.combineLatest(
            output.academyCoursesSectionTitle,
            output.academyCourseViewModels
        )
        
        let source = Driver<TableSource>
            .combineLatest(
                generalOutput,
                bountiesOutput,
                academyOutput,
                resultSelector: { general, bounties, academy -> TableSource in
                    return TableSource(
                        newsSectionTitle: general.0,
                        bountiesSectionTitle: bounties.0,
                        bountyViewModels: bounties.1,
                        academyCoursesSectionTitle: academy.0,
                        academyCourseViewModels: academy.1,
                        expandSectionButtonTitle: general.1
                    )
                })
        
        source.drive(self.source).disposed(by: disposer)
        
        self.source
            .subscribe(onNext: { [weak self] _ in self?.tableView.reloadData() })
            .disposed(by: disposer)
    }
    
    private func input() -> HomeTimelineViewModel.Input {
        return HomeTimelineViewModel.Input(
            refresh: refreshTrigger.asDriver(onErrorDriveWith: .empty()),
            selection: tableView.rx.itemSelected.asDriver(),
            expandSection: sectionExpandButtonRelay.asDriver(onErrorDriveWith: .empty())
        )
    }
    
    // MARK: - Data source -
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.source.value.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        let row = self.source.value.translateGlobalRow(at: indexPath.row)
        
        switch row.sectionType {
            
        case .news:
            switch self.source.value.newsSection.rowType(at: row.localIndex) {
                
            case .header:
                let newsCell = FeaturedNewsCell()
                newsCell.set(title: self.source.value.newsSection.title ?? "")
                cell = newsCell
            case .content:
                fatalError("not implemented")
            }
        case .bounties:
            switch self.source.value.bountiesSection.rowType(at: row.localIndex) {
                
            case .header:
                let bountiesHeaderCell = TimelineSectionHeaderCell()
                bountiesHeaderCell.set(title: self.source.value.bountiesSection.title ?? "")
                bountiesHeaderCell.setExpandButton(
                    title: self.source.value.expandSectionButtonTitle
                ) {
                    // TODO: Handle section expand event
                }
                cell = bountiesHeaderCell
            case .content:
                let bountyViewModel = self.source.value
                    .bountiesSection
                    .viewModels[
                        row.localIndex
                            - (self.source.value.bountiesSection.hasHeader ? 1 : 0)
                    ]
                
                let bountyCell = tableView
                    .dequeueReusableCell(
                        withIdentifier: BountyListCell.reuseIdentifier,
                        for: indexPath
                    ) as! BountyListCell
                
                bountyCell.set(viewModel: bountyViewModel)
                
                cell = bountyCell
            }
        case .academy:
            switch self.source.value.academyCoursesSection.rowType(at: row.localIndex) {
                
            case .header:
                let academyCoursesHeaderCell = TimelineSectionHeaderCell()
                academyCoursesHeaderCell.set(
                    title: self.source.value.academyCoursesSection.title ?? ""
                )
                academyCoursesHeaderCell.setExpandButton(
                    title: self.source.value.expandSectionButtonTitle
                ) {
                    // TODO: Handle section expand event
                }
                cell = academyCoursesHeaderCell
            case .content:
                let academyCourseViewModel = self.source.value
                    .academyCoursesSection
                    .viewModels[
                        row.localIndex
                            - (self.source.value.academyCoursesSection.hasHeader ? 1 : 0)
                    ]
                
                let academyCourseCell = tableView
                    .dequeueReusableCell(
                        withIdentifier: AcademyCourseListCell.reuseIdentifier,
                        for: indexPath
                    ) as! AcademyCourseListCell
                
                academyCourseCell.set(viewModel: academyCourseViewModel)
                
                cell = academyCourseCell
            }
        }
        
        return cell
    }
}

extension HomeTimelineView {
    struct TableSource {
        let expandSectionButtonTitle: String
        let newsSection: Section<FeaturedNewsViewModel>
        let bountiesSection: Section<BountyViewModel>
        let academyCoursesSection: Section<AcademyCourseViewModel>
        
        var numberOfRows: Int {
            return newsSection.numberOfRows
                + bountiesSection.numberOfRows
                + academyCoursesSection.numberOfRows
        }
        
        init(
            newsSectionTitle: String,
            bountiesSectionTitle: String,
            bountyViewModels: [BountyViewModel],
            academyCoursesSectionTitle: String,
            academyCourseViewModels: [AcademyCourseViewModel],
            expandSectionButtonTitle: String
        ) {
            self.expandSectionButtonTitle = expandSectionButtonTitle
            self.newsSection = .init(
                type: .news,
                title: newsSectionTitle,
                isExpandable: false,
                viewModels: []
            )
            self.bountiesSection = .init(
                type: .bounties,
                title: bountiesSectionTitle,
                isExpandable: true,
                viewModels: bountyViewModels
            )
            self.academyCoursesSection = .init(
                type: .academy,
                title: academyCoursesSectionTitle,
                isExpandable: true,
                viewModels: academyCourseViewModels
            )
        }
        
        init() {
            self.expandSectionButtonTitle = ""
            self.newsSection = .init(
                type: .news,
                title: "",
                isExpandable: false,
                viewModels: []
            )
            self.bountiesSection = .init(
                type: .bounties,
                title: "",
                isExpandable: true,
                viewModels: []
            )
            self.academyCoursesSection = .init(
                type: .academy,
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
            
            if localIndex < newsSection.numberOfRows {
                return (sectionType: .news, localIndex: localIndex)
            }
            
            localIndex -= newsSection.numberOfRows
            if localIndex < bountiesSection.numberOfRows {
                return (sectionType: .bounties, localIndex: localIndex)
            }
            
            localIndex -= bountiesSection.numberOfRows
            if localIndex < academyCoursesSection.numberOfRows {
                return (sectionType: .academy, localIndex: localIndex)
            }
            
            fatalError("section not found")
        }
    }
}

extension HomeTimelineView.TableSource {
    enum SectionType {
        case news
        case bounties
        case academy
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
            guard index < numberOfRows else {
                fatalError("index is outside the bounds")
            }
            
            if hasHeader && index == 0 {
                return .header
            }
            
            return .content
        }
    }
}

extension HomeTimelineView.TableSource.Section {
    enum Row {
        enum `Type` {
            case header
            case content
        }
    }
}
