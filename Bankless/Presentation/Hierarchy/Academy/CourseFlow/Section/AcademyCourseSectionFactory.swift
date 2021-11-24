//
//  Created with ♥ by BanklessDAO contributors on 2021-11-22.
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

final class AcademyCourseSectionFactory {
    static func createSectionViewModel(
        for section: AcademyCourse.Section
    ) -> AcademyCourseSectionViewModel {
        switch section.type {
            
        case .learn:
            let viewModel = AcademyCourseLearnSectionViewModel(section: section)
            return viewModel
        case .quiz:
            let viewModel = AcademyCourseQuizSectionViewModel(section: section)
            return viewModel
        case .quest:
            fatalError("not implemented")
        case .poap:
            let viewModel = AcademyCoursePoapSectionViewModel(section: section)
            return viewModel
        }
    }
    
    static func createSectionView(
        for viewModel: AcademyCourseSectionViewModel
    ) -> AcademyCourseSectionView {
        switch viewModel {
            
        case let targetVM as AcademyCourseLearnSectionViewModel:
            let view = AcademyCourseLearnSectionView()
            view.set(viewModel: targetVM)
            return view
        case let targetVM as AcademyCourseQuizSectionViewModel:
            let view = AcademyCourseQuizSectionView()
            view.set(viewModel: targetVM)
            return view
        case let targetVM as AcademyCoursePoapSectionViewModel:
            let view = AcademyCoursePoapSectionView()
            view.set(viewModel: targetVM)
            return view
        default:
            fatalError("not implemented")
        }
    }
}
