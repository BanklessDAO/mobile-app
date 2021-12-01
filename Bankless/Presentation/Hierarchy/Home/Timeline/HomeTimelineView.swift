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
    
    private let sectionExpandButtonRelay = PublishRelay<Int>()
    
    // MARK: - Subviews -
    
    private(set) var tableView: UITableView!
    private var refreshControl: UIRefreshControl!
    
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
        setUpTable()
    }
    
    private func setUpTable() {
        backgroundColor = .backgroundBlack
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .backgroundBlack
        tableView.tableHeaderView = UIView(frame: .zero)
        tableView.tableFooterView = UIView(
            frame: .init(x: 0, y: 0, width: 0, height: contentInsets.bottom * 2)
        )
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.showsVerticalScrollIndicator = false
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(
            GaugeClusterCell.self,
            forCellReuseIdentifier: GaugeClusterCell.reuseIdentifier
        )
        
        tableView.register(
            FeaturedNewsCell.self,
            forCellReuseIdentifier: FeaturedNewsCell.reuseIdentifier
        )
        
        tableView.register(
            SectionHeaderCell.self,
            forCellReuseIdentifier: SectionHeaderCell.reuseIdentifier
        )
        
        tableView.register(
            BountyListCell.self,
            forCellReuseIdentifier: BountyListCell.reuseIdentifier
        )
        
        tableView.register(
            AcademyCourseListCell.self,
            forCellReuseIdentifier: AcademyCourseListCell.reuseIdentifier
        )
        
        refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl)
        
        addSubview(tableView)
    }
    
    func setUpConstraints() {
        constrain(tableView, self) { (table, view) in
            table.left == view.safeAreaLayoutGuide.left
            table.right == view.safeAreaLayoutGuide.right
            table.top == view.safeAreaLayoutGuide.top
            table.bottom == view.bottom
        }
    }
    
    override func bindViewModel() {
        let output = viewModel.transform(input: input())
        
        output.isRefreshing.drive(refreshControl.rx.isRefreshing).disposed(by: disposer)
        
        let bountiesOutput = Driver.combineLatest(
            output.bountiesSectionHeaderViewModel,
            output.bountyViewModels
        )
        
        let academyOutput = Driver.combineLatest(
            output.academyCoursesSectionHeaderViewModel,
            output.academyCourseViewModels
        )
        
        let source = Driver<ListSource>
            .combineLatest(
                output.gaugeClusterViewModel,
                output.featuredNewsViewModel,
                bountiesOutput,
                academyOutput,
                resultSelector: {
                    gaugeCluster,
                    featuredNews,
                    bounties,
                    academy -> ListSource in
                    
                    return ListSource(
                        gaugeClusterViewModel: gaugeCluster,
                        featuredNewsViewModel: featuredNews,
                        bountiesHeaderViewModel: bounties.0,
                        bountyViewModels: bounties.1,
                        academyHeaderViewModel: academy.0,
                        academyCourseViewModels: academy.1
                    )
                })
        
        source.drive(self.source).disposed(by: disposer)
        
        self.source
            .subscribe(onNext: { [weak self] _ in self?.tableView.reloadData() })
            .disposed(by: disposer)
    }
    
    private func input() -> HomeTimelineViewModel.Input {
        let selection = tableView.rx.itemSelected.asDriver()
            .map({ indexPath -> ViewModelFoundation? in
                let row = self.source.value.translateGlobalRow(at: indexPath.row)
                
                switch row.sectionType {
                    
                case .gaugeCluster:
                    return nil
                case .news:
                    return nil
                case .bounties:
                    return self.source.value.bountiesSection.rowViewModel(at: row.index)
                case .academy:
                    return self.source.value.academyCoursesSection.rowViewModel(at: row.index)
                }
            })
            .filter({ $0 != nil }).map({ $0! })
        
        return HomeTimelineViewModel.Input(
            refresh: refreshControl.rx.controlEvent(.valueChanged).asDriver(),
            selection: selection.asDriver(),
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
        
        case .gaugeCluster:
            switch self.source.value.gaugeClusterSection.rowPayload(at: row.index) {
                
            case .header:
                fatalError("not implemented")
            case let .content(viewModel):
                let gaugeClusterCell = tableView
                    .dequeueReusableCell(
                        withIdentifier: GaugeClusterCell.reuseIdentifier,
                        for: indexPath
                    ) as! GaugeClusterCell
                
                gaugeClusterCell.set(viewModel: viewModel)
                
                cell = gaugeClusterCell
            }
        case .news:
            switch self.source.value.newsSection.rowPayload(at: row.index) {
                
            case .header:
                fatalError("not implemented")
            case let .content(viewModel):
                let newsCell = tableView
                    .dequeueReusableCell(
                        withIdentifier: FeaturedNewsCell.reuseIdentifier,
                        for: indexPath
                    ) as! FeaturedNewsCell
                newsCell.set(viewModel: viewModel)
                cell = newsCell
            }
        case .bounties:
            switch self.source.value.bountiesSection.rowPayload(at: row.index) {
                
            case let .header(viewModel):
                let bountiesHeaderCell = tableView
                    .dequeueReusableCell(
                        withIdentifier: SectionHeaderCell.reuseIdentifier,
                        for: indexPath
                    ) as! SectionHeaderCell
                bountiesHeaderCell.set(viewModel: viewModel)
                cell = bountiesHeaderCell
            case let .content(viewModel):
                let bountyCell = tableView
                    .dequeueReusableCell(
                        withIdentifier: BountyListCell.reuseIdentifier,
                        for: indexPath
                    ) as! BountyListCell
                
                bountyCell.set(viewModel: viewModel)
                
                cell = bountyCell
            }
        case .academy:
            switch self.source.value.academyCoursesSection.rowPayload(at: row.index) {
                
            case let .header(viewModel):
                let academyCoursesHeaderCell = tableView
                    .dequeueReusableCell(
                        withIdentifier: SectionHeaderCell.reuseIdentifier,
                        for: indexPath
                    ) as! SectionHeaderCell
                academyCoursesHeaderCell.set(viewModel: viewModel)
                cell = academyCoursesHeaderCell
            case let .content(viewModel):
                let academyCourseCell = tableView
                    .dequeueReusableCell(
                        withIdentifier: AcademyCourseListCell.reuseIdentifier,
                        for: indexPath
                    ) as! AcademyCourseListCell
                
                academyCourseCell.set(viewModel: viewModel)
                
                cell = academyCourseCell
            }
        }
        
        return cell
    }
    
    // MARK: - Delegate -
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension HomeTimelineView {
    class ListSource: BaseSectionedSource<ListSectionType>, SectionedSourceRequirements {
        typealias SectionType = ListSectionType
        typealias Row = SectionRow
        
        let gaugeClusterSection: ListSource.Section<Void, GaugeClusterViewModel>
        let newsSection: ListSource.Section<Void, FeaturedNewsViewModel>
        let bountiesSection: ListSource.Section<
            SectionHeaderViewModel, BountyViewModel
        >
        let academyCoursesSection: ListSource.Section<
            SectionHeaderViewModel, AcademyCourseViewModel
        >
        
        var numberOfRows: Int {
            return gaugeClusterSection.numberOfRows
            + newsSection.numberOfRows
            + bountiesSection.numberOfRows
            + academyCoursesSection.numberOfRows
        }
        
        init(
            gaugeClusterViewModel: GaugeClusterViewModel,
            featuredNewsViewModel: FeaturedNewsViewModel,
            bountiesHeaderViewModel: SectionHeaderViewModel,
            bountyViewModels: [BountyViewModel],
            academyHeaderViewModel: SectionHeaderViewModel,
            academyCourseViewModels: [AcademyCourseViewModel]
        ) {
            self.gaugeClusterSection = .init(
                type: .gaugeCluster,
                viewModels: [gaugeClusterViewModel]
            )
            
            self.newsSection = .init(
                type: .news,
                viewModels: [featuredNewsViewModel]
            )
            
            self.bountiesSection = .init(
                type: .bounties,
                headerViewModel: bountiesHeaderViewModel,
                viewModels: bountyViewModels
            )
            
            self.academyCoursesSection = .init(
                type: .academy,
                headerViewModel: academyHeaderViewModel,
                viewModels: academyCourseViewModels
            )
        }
        
        override init() {
            self.gaugeClusterSection = .init(
                type: .gaugeCluster,
                viewModels: []
            )
            
            self.newsSection = .init(
                type: .news,
                viewModels: []
            )
            
            self.bountiesSection = .init(
                type: .bounties,
                viewModels: []
            )
            
            self.academyCoursesSection = .init(
                type: .academy,
                viewModels: []
            )
        }
        
        func translateGlobalRow(at index: Int) -> ListSource.SectionRow {
            guard index < numberOfRows else {
                fatalError("index is outside the bounds")
            }
            
            var localIndex = index
            
            if localIndex < gaugeClusterSection.numberOfRows {
                return ListSource.SectionRow(sectionType: .gaugeCluster, index: localIndex)
            }
            
            localIndex -= gaugeClusterSection.numberOfRows
            if localIndex < newsSection.numberOfRows {
                return ListSource.SectionRow(sectionType: .news, index: localIndex)
            }
            
            localIndex -= newsSection.numberOfRows
            if localIndex < bountiesSection.numberOfRows {
                return ListSource.SectionRow(sectionType: .bounties, index: localIndex)
            }
            
            localIndex -= bountiesSection.numberOfRows
            if localIndex < academyCoursesSection.numberOfRows {
                return ListSource.SectionRow(sectionType: .academy, index: localIndex)
            }
            
            fatalError("section not found")
        }
    }
    
    enum ListSectionType: SectionedSourceSectionType {
        case gaugeCluster
        case news
        case bounties
        case academy
    }
}
