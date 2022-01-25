//
//  Created with ♥ by BanklessDAO contributors on 2021-11-17.
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

class NewsViewController: BaseViewController<NewsViewModel>,
                                 UITableViewDataSource,
                                 UITableViewDelegate
{
    // MARK: - Properties -
    
    let source = BehaviorRelay<ListSource>(value: .init())
    let endOfListRelay = PublishRelay<Int>()
    
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
        listView.showsVerticalScrollIndicator = false
        
        listView.dataSource = self
        listView.delegate = self
        
        listView.register(
            NewsHeaderCell.self,
            forCellReuseIdentifier: NewsHeaderCell.reuseIdentifier
        )
        
        listView.register(
            NewsItemListCell.self,
            forCellReuseIdentifier: NewsItemListCell.reuseIdentifier
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
                output.newsItemViewModels,
                resultSelector: { title, newsItems -> ListSource in
                    return ListSource(
                        title: title,
                        newsItemViewModels: newsItems
                    )
                })
        
        source.drive(self.source).disposed(by: disposer)
        
        self.source
            .subscribe(onNext: { [weak self] _ in self?.listView.reloadData() })
            .disposed(by: disposer)
    }
    
    private func input() -> NewsViewModel.Input {
        let selection = listView.rx.itemSelected.asDriver()
            .map({ [weak self] indexPath -> ViewModelFoundation? in
                guard let self = self else { return nil }
                
                let row = self.source.value.translateGlobalRow(at: indexPath.row)
                
                switch row.sectionType {
                    
                case .header:
                    return nil
                case .newsItems:
                    return self.source.value.newsItemsSection.rowViewModel(at: row.index)
                }
            })
            .filter({ $0 != nil }).map({ $0! })
        
        return NewsViewModel.Input(
            refresh: refreshControl.rx.controlEvent(.valueChanged).asDriver(),
            endOfList: endOfListRelay.asDriver(onErrorDriveWith: .empty()).distinctUntilChanged(),
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
                        withIdentifier: NewsHeaderCell.reuseIdentifier,
                        for: indexPath
                    ) as! NewsHeaderCell
                headerCell.set(title: viewModel.title)
                cell = headerCell
            }
        case .newsItems:
            switch self.source.value.newsItemsSection.rowPayload(at: row.index) {
                
            case .header:
                fatalError("not implemented")
            case let .content(viewModel):
                let newsItemCell = listView
                    .dequeueReusableCell(
                        withIdentifier: NewsItemListCell.reuseIdentifier,
                        for: indexPath
                    ) as! NewsItemListCell
                
                newsItemCell.set(viewModel: viewModel)
                
                cell = newsItemCell
            }
        }
        
        return cell
    }
    
    // MARK: - Delegate -
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        guard indexPath.row == self.source.value.numberOfRows - 1 else {
            return
        }
        
        endOfListRelay.accept(self.source.value.numberOfRows)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listView.deselectRow(at: indexPath, animated: false)
    }
}

extension NewsViewController {
    class ListSource: BaseSectionedSource<ListSectionType>, SectionedSourceRequirements {
        typealias SectionType = ListSectionType
        typealias Row = SectionRow
        
        let headerSection: ListSource.Section<Void, NewsHeaderViewModel>
        let newsItemsSection: ListSource.Section<Void, NewsItemViewModel>
        
        var numberOfRows: Int {
            return headerSection.numberOfRows
            + newsItemsSection.numberOfRows
        }
        
        init(
            title: String,
            newsItemViewModels: [NewsItemViewModel]
        ) {
            self.headerSection = .init(
                type: .header,
                viewModels: [
                    NewsHeaderViewModel(title: title)
                ]
            )
            
            self.newsItemsSection = .init(
                type: .newsItems,
                viewModels: newsItemViewModels
            )
        }
        
        override init() {
            self.headerSection = .init(
                type: .header,
                viewModels: [
                    NewsHeaderViewModel(title: "")
                ]
            )
            
            self.newsItemsSection = .init(
                type: .newsItems,
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
            if localIndex < newsItemsSection.numberOfRows {
                return SectionRow(sectionType: .newsItems, index: localIndex)
            }
            
            fatalError("section not found")
        }
    }
    
    enum ListSectionType: SectionedSourceSectionType {
        case header
        case newsItems
    }
}
