//
//  Created with ♥ by BanklessDAO contributors on 2021-10-06.
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

class TagView: AutoWidthLabel {
	// MARK: - Properties -
	
	var borderColor: UIColor? {
		didSet {
			layer.borderColor = (borderColor ?? .clear).cgColor
		}
	}
	
	var borderWidth: CGFloat? {
		didSet {
			layer.borderWidth = borderWidth ?? 0
		}
	}
	
	var cornerRadius: CGFloat? {
		didSet {
			layer.cornerRadius = cornerRadius ?? 0
		}
	}
	
	// MARK: - Initializers -
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setUp()
	}
	
	override func setUp() {
		super.setUp()
		setUpAppearance()
	}
	
	private func setUpAppearance() {
		horizontalPadding = 10
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Life cycle -
	
	override func layoutSubviews() {
		super.layoutSubviews()
		layer.cornerRadius = layer.cornerRadius
	}
}
