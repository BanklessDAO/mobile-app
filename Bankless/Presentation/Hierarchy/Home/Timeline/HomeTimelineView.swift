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
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.contentInsetAdjustmentBehavior = .never
        
        tableView.dataSource = self
        tableView.delegate = self
        
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
            table.edges == view.edges
        }
    }
    
    override func bindViewModel() {
        let output = viewModel.transform(input: input())
        
        fatalError("not implemented")
    }
    
    private func input() -> HomeTimelineViewModel.Input {
        return HomeTimelineViewModel.Input(
            refresh: refreshTrigger.asDriver(onErrorDriveWith: .empty()),
            selection: tableView.rx.itemSelected.asDriver(),
            expandSection: sectionExpandButtonRelay.asDriver(onErrorDriveWith: .empty())
        )
    }
    
    // MARK: - Data source -
    
    func numberOfSections(in tableView: UITableView) -> Int {
        fatalError("not implemented")
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        fatalError("not implemented")
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        fatalError("not implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fatalError("not implemented")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fatalError("not implemented")
    }
}

extension HomeTimelineView {
    struct TableSource {
        let title: String
        let bountiesSectionTitle: String
        let bountyViewModels: [BountyViewModel]
        let academyCoursesSectionTitle: String
        let academyCourseViewModels: [AcademyCourseViewModel]
        let expandSectionButtonTitle: String
        
        init(
            title: String,
            bountiesSectionTitle: String,
            bountyViewModels: [BountyViewModel],
            academyCoursesSectionTitle: String,
            academyCourseViewModels: [AcademyCourseViewModel],
            expandSectionButtonTitle: String
        ) {
            self.title = title
            self.bountiesSectionTitle = bountiesSectionTitle
            self.bountyViewModels = bountyViewModels
            self.academyCoursesSectionTitle = academyCoursesSectionTitle
            self.academyCourseViewModels = academyCourseViewModels
            self.expandSectionButtonTitle = expandSectionButtonTitle
        }
        
        init() {
            self.title = ""
            self.bountiesSectionTitle = ""
            self.bountyViewModels = []
            self.academyCoursesSectionTitle = ""
            self.academyCourseViewModels = []
            self.expandSectionButtonTitle = ""
        }
    }
}
