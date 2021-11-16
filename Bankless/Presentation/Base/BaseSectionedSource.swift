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

protocol SectionedSourceRequirements {
    associatedtype SectionType: SectionedSourceSectionType
    associatedtype Row: SectionedSourceSectionRow
    
    var numberOfRows: Int { get }
    
    func translateGlobalRow(at index: Int) -> Row
}

protocol SectionedSourceSectionType: Equatable { }
protocol SectionedSourceSectionRow {
    associatedtype SectionType: SectionedSourceSectionType
    
    var sectionType: SectionType { get }
    var index: Int { get }
}

protocol SectionedSourceSection {
    associatedtype SectionType: SectionedSourceSectionType
    associatedtype HeaderVM
    associatedtype ContentVM
    associatedtype RowPayload
    
    var type: SectionType { get }
    var headerViewModel: HeaderVM? { get }
    var viewModels: [ContentVM] { get }
    var rowPayloads: [RowPayload] { get }
}

class BaseSectionedSource<SectionType> where SectionType: SectionedSourceSectionType {
    struct Section<HeaderVM, ContentVM>: SectionedSourceSection {
        enum RowPayload {
            case header(viewModel: HeaderVM)
            case content(viewModel: ContentVM)
        }
        
        let type: SectionType
        let headerViewModel: HeaderVM?
        let viewModels: [ContentVM]
        
        var isEmpty: Bool {
            return viewModels.isEmpty
        }
        
        var numberOfRows: Int {
            guard !isEmpty else { return 0 }
            return (headerViewModel != nil ? 1 : 0)
            + viewModels.count
        }
        
        var rowPayloads: [RowPayload] {
            var payloads: [RowPayload] = []
            
            for i in 0 ..< numberOfRows {
                payloads.append(rowPayload(at: i))
            }
            
            return payloads
        }
        
        init(
            type: SectionType,
            viewModels: [ContentVM]
        ) {
            self.type = type
            self.headerViewModel = nil
            self.viewModels = viewModels
        }
        
        init(
            type: SectionType,
            headerViewModel: HeaderVM,
            viewModels: [ContentVM]
        ) {
            self.type = type
            self.headerViewModel = headerViewModel
            self.viewModels = viewModels
        }
        
        func rowPayload(at index: Int) -> RowPayload {
            guard index < numberOfRows else {
                fatalError("index is outside the bounds")
            }
            
            var contentOffset = 0
            
            if let headerViewModel = self.headerViewModel {
                contentOffset = 1
                
                if index == 0 {
                    return .header(viewModel: headerViewModel)
                }
            }
            
            return .content(viewModel: viewModels[index - contentOffset])
        }
        
        func rowViewModel(at index: Int) -> ViewModelFoundation {
            guard index < numberOfRows else {
                fatalError("index is outside the bounds")
            }
            
            var contentOffset = 0
            
            if let headerViewModel = self.headerViewModel {
                contentOffset = 1
                
                if index == 0 {
                    return headerViewModel as! ViewModelFoundation
                }
            }
            
            return viewModels[index - contentOffset] as! ViewModelFoundation
        }
    }
    
    struct SectionRow: SectionedSourceSectionRow {
        let sectionType: SectionType
        let index: Int
        
        init(sectionType: SectionType, index: Int) {
            self.sectionType = sectionType
            self.index = index
        }
    }
}
