//
//  Created with ♥ by BanklessDAO contributors on 2021-11-18.
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

class AcademyViewController: BaseViewController<AcademyViewModel>,
                                 UITableViewDataSource,
                                 UITableViewDelegate
{
    // MARK: - Properties -
    
    let source = BehaviorRelay<ListSource>(value: .init())
    
    // MARK: - Subviews -
    
    private var listView: UITableView!
    
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
            AcademyHeaderCell.self,
            forCellReuseIdentifier: AcademyHeaderCell.reuseIdentifier
        )
        
        listView.register(
            AcademyCourseListCell.self,
            forCellReuseIdentifier: AcademyCourseListCell.reuseIdentifier
        )
        
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
        
        let source = Driver<ListSource>
            .combineLatest(
                output.title,
                output.academyCourseViewModels,
                resultSelector: { title, academyCourses -> ListSource in
                    return ListSource(
                        title: title,
                        academyCourseViewModels: academyCourses
                    )
                })
        
        source.drive(self.source).disposed(by: disposer)
        
        self.source
            .subscribe(onNext: { [weak self] _ in self?.listView.reloadData() })
            .disposed(by: disposer)
    }
    
    private func input() -> AcademyViewModel.Input {
        let selection = listView.rx.itemSelected.asDriver()
            .map({ [weak self] indexPath -> ViewModelFoundation? in
                guard let self = self else { return nil }
                
                let row = self.source.value.translateGlobalRow(at: indexPath.row)
                
                switch row.sectionType {
                    
                case .header:
                    return nil
                case .academyCourses:
                    return self.source.value.academyCoursesSection.rowViewModel(at: row.index)
                }
            })
            .filter({ $0 != nil }).map({ $0! })
        
        return AcademyViewModel.Input(
            refresh: .just(()),
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
                        withIdentifier: AcademyHeaderCell.reuseIdentifier,
                        for: indexPath
                    ) as! AcademyHeaderCell
                headerCell.set(title: viewModel.title)
                cell = headerCell
            }
        case .academyCourses:
            switch self.source.value.academyCoursesSection.rowPayload(at: row.index) {
                
            case .header:
                fatalError("not implemented")
            case let .content(viewModel):
                let academyCourseCell = listView
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
        listView.deselectRow(at: indexPath, animated: false)
    }
}

extension AcademyViewController {
    class ListSource: BaseSectionedSource<ListSectionType>, SectionedSourceRequirements {
        typealias SectionType = ListSectionType
        typealias Row = SectionRow
        
        let headerSection: ListSource.Section<Void, AcademyHeaderViewModel>
        let academyCoursesSection: ListSource.Section<Void, AcademyCourseViewModel>
        
        var numberOfRows: Int {
            return headerSection.numberOfRows
            + academyCoursesSection.numberOfRows
        }
        
        init(
            title: String,
            academyCourseViewModels: [AcademyCourseViewModel]
        ) {
            self.headerSection = .init(
                type: .header,
                viewModels: [
                    AcademyHeaderViewModel(title: title)
                ]
            )
            
            self.academyCoursesSection = .init(
                type: .academyCourses,
                viewModels: academyCourseViewModels
            )
        }
        
        override init() {
            self.headerSection = .init(
                type: .header,
                viewModels: [
                    AcademyHeaderViewModel(title: "")
                ]
            )
            
            self.academyCoursesSection = .init(
                type: .academyCourses,
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
            if localIndex < academyCoursesSection.numberOfRows {
                return SectionRow(sectionType: .academyCourses, index: localIndex)
            }
            
            fatalError("section not found")
        }
    }
    
    enum ListSectionType: SectionedSourceSectionType {
        case header
        case academyCourses
    }
}