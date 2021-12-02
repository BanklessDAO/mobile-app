//
//  Created with ♥ by BanklessDAO contributors on 2021-11-11.
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
import RxSwift
import RxCocoa
import Cartography

class BountyBoardViewController: BaseViewController<BountyBoardViewModel>,
                                 UITableViewDataSource,
                                 UITableViewDelegate
{
    // MARK: - Properties -
    
    let source = BehaviorRelay<ListSource>(value: .init())
    
    // MARK: - Subviews -
    
    private var listView: UITableView!
    private var refreshControl: UIRefreshControl!
    
    // MARK: - Setup -
    
    override func setUp() {
        setUpSubviews()
        setUpConstraints()
        bindViewModel()
    }
    
    func setUpSubviews() {
        view.backgroundColor = .backgroundBlack
        
        listView = UITableView(frame: .zero, style: .plain)
        listView.backgroundColor = .backgroundBlack
        listView.tableHeaderView = UIView(frame: .zero)
        listView.tableFooterView = UIView(
            frame: .init(x: 0, y: 0, width: 0, height: contentInsets.bottom * 2)
        )
        listView.contentInsetAdjustmentBehavior = .never
        
        listView.dataSource = self
        listView.delegate = self
        
        listView.register(
            BountyBoardHeaderCell.self,
            forCellReuseIdentifier: BountyBoardHeaderCell.reuseIdentifier
        )
        
        listView.register(
            BountyListCell.self,
            forCellReuseIdentifier: BountyListCell.reuseIdentifier
        )
        
        refreshControl = UIRefreshControl()
        listView.addSubview(refreshControl)
        
        view.addSubview(listView)
    }
    
    func setUpConstraints() {
        constrain(listView, view) { (list, view) in
            list.left == view.safeAreaLayoutGuide.left
            list.right == view.safeAreaLayoutGuide.right
            list.top == view.safeAreaLayoutGuide.top
            list.bottom == view.bottom
        }
    }
    
   func bindViewModel() {
        let output = viewModel.transform(input: input())
       
       output.isRefreshing.drive(refreshControl.rx.isRefreshing).disposed(by: disposer)
        
        let source = Driver<ListSource>
            .combineLatest(
                output.title,
                output.bountyViewModels,
                resultSelector: { title, bounties -> ListSource in
                    return ListSource(
                        title: title,
                        bountyViewModels: bounties
                    )
                })
        
        source.drive(self.source).disposed(by: disposer)
        
        self.source
            .subscribe(onNext: { [weak self] _ in self?.listView.reloadData() })
            .disposed(by: disposer)
    }
    
    private func input() -> BountyBoardViewModel.Input {
        let selection = listView.rx.itemSelected.asDriver()
            .map({ [weak self] indexPath -> ViewModelFoundation? in
                guard let self = self else { return nil }
                
                let row = self.source.value.translateGlobalRow(at: indexPath.row)
                
                switch row.sectionType {
                    
                case .header:
                    return nil
                case .bounties:
                    return self.source.value.bountiesSection.rowViewModel(at: row.index)
                }
            })
            .filter({ $0 != nil }).map({ $0! })
        
        return BountyBoardViewModel.Input(
            refresh: refreshControl.rx.controlEvent(.valueChanged).asDriver(),
            selection: selection
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
            
        case .header:
            switch self.source.value.headerSection.rowPayload(at: row.index) {
                
            case .header:
                fatalError("not implemented")
            case let .content(viewModel):
                let headerCell = listView
                    .dequeueReusableCell(
                        withIdentifier: BountyBoardHeaderCell.reuseIdentifier,
                        for: indexPath
                    ) as! BountyBoardHeaderCell
                headerCell.set(title: viewModel.title)
                cell = headerCell
            }
        case .bounties:
            switch self.source.value.bountiesSection.rowPayload(at: row.index) {
                
            case .header:
                fatalError("not implemented")
            case let .content(viewModel):
                let bountyCell = listView
                    .dequeueReusableCell(
                        withIdentifier: BountyListCell.reuseIdentifier,
                        for: indexPath
                    ) as! BountyListCell
                
                bountyCell.set(viewModel: viewModel)
                
                cell = bountyCell
            }
        }
        
        return cell
    }
    
    // MARK: - Delegate -
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listView.deselectRow(at: indexPath, animated: false)
    }
}

extension BountyBoardViewController {
    class ListSource: BaseSectionedSource<ListSectionType>, SectionedSourceRequirements {
        typealias SectionType = ListSectionType
        typealias Row = SectionRow
        
        let headerSection: ListSource.Section<Void, BountyBoardHeaderViewModel>
        let bountiesSection: ListSource.Section<Void, BountyViewModel>
        
        var numberOfRows: Int {
            return headerSection.numberOfRows
            + bountiesSection.numberOfRows
        }
        
        init(
            title: String,
            bountyViewModels: [BountyViewModel]
        ) {
            self.headerSection = .init(
                type: .header,
                viewModels: [
                    BountyBoardHeaderViewModel(title: title)
                ]
            )
            
            self.bountiesSection = .init(
                type: .bounties,
                viewModels: bountyViewModels
            )
        }
        
        override init() {
            self.headerSection = .init(
                type: .header,
                viewModels: [
                    BountyBoardHeaderViewModel(title: "")
                ]
            )
            
            self.bountiesSection = .init(
                type: .bounties,
                viewModels: []
            )
        }
        
        func translateGlobalRow(at index: Int) -> SectionRow {
            guard index < numberOfRows else {
                fatalError("index is outside the bounds")
            }
            
            var localIndex = index
            
            if localIndex < headerSection.numberOfRows {
                return SectionRow(sectionType: .header, index: localIndex)
            }
            
            localIndex -= headerSection.numberOfRows
            if localIndex < bountiesSection.numberOfRows {
                return SectionRow(sectionType: .bounties, index: localIndex)
            }
            
            fatalError("section not found")
        }
    }
    
    enum ListSectionType: SectionedSourceSectionType {
        case header
        case bounties
    }
}
